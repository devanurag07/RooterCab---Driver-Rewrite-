// lib/core/network/socket/socket_service.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'i_socket_service.dart';

/// Provides auth tokens. Implementation should read from secure storage and
/// refresh if needed. Kept as a function type to avoid tight coupling.
typedef TokenProvider = Future<String?> Function();

/// Optional logger to hook into your app logging.
typedef Logger = void Function(String message, [Object? error, StackTrace? st]);

class SocketService implements ISocketService {
  // -------------------- Singleton bootstrapping --------------------

  static SocketService? _instance;
  Function()? _onConnect;

  /// Initialize the singleton once at app bootstrap.
  /// If called again, returns the existing instance.
  static SocketService init({
    required Uri baseUri,
    required TokenProvider tokenProvider,
    Logger? logger,
    Duration pingInterval = const Duration(seconds: 20),
    Duration connectTimeout = const Duration(seconds: 10),
  }) {
    _instance ??= SocketService._(
      baseUri: baseUri,
      tokenProvider: tokenProvider,
      logger: logger ??
          ((m, [e, s]) => debugPrint('[SOCKET] $m ${e ?? ''} ${s ?? ''}')),
      pingInterval: pingInterval,
      connectTimeout: connectTimeout,
    );
    return _instance!;
  }

  /// Get the singleton instance after [init] has been called.
  static SocketService get I {
    final i = _instance;
    if (i == null) {
      throw StateError(
          'SocketService not initialized. Call SocketService.init(...) at bootstrap.');
    }
    return i;
  }

  // -------------------- Construction --------------------

  SocketService._({
    required this.baseUri,
    required this.tokenProvider,
    required this.logger,
    required this.pingInterval,
    required this.connectTimeout,
  });

  final Uri baseUri;
  final TokenProvider tokenProvider;
  final Logger logger;
  final Duration pingInterval;
  final Duration connectTimeout;

  io.Socket? _socket;
  bool _manualDisconnect = false;
  bool _connecting = false;

  /// Queue to hold emit calls while offline; flushed on connect/reconnect.
  final List<_Queued> _queue = [];

  Timer? _heartbeatTimer;

  @override
  bool get isConnected => _socket?.connected == true;

  // -------------------- Public API --------------------

  @override
  Future<void> connect() async {
    // Prevent parallel connects and ignored if already connected.
    if (_connecting || isConnected) return;
    _connecting = true;
    _manualDisconnect = false;

    try {
      final token = await tokenProvider();

      // Build socket.io connection options; include auth if available.
      final opts = <String, dynamic>{
        'transports': ['websocket'],
        'auth': {
          'token': token,
        },
        'forceNew': true, // fresh engine for each connect
        'reconnection': true, // enable backoff reconnection
        'reconnectionAttempts': 1 << 31, // effectively "infinite"
        'reconnectionDelay': 500, // ms
        'reconnectionDelayMax': 8000, // ms
        'timeout': connectTimeout.inMilliseconds,
        'autoConnect': true,
        'extraHeaders':
            token == null ? null : {'Authorization': 'Bearer $token'},
        'query': token == null ? null : {'token': token},
      };

      _socket = io.io(baseUri.toString(), opts);
      _setupCoreHandlers();
    } catch (e, s) {
      logger('connect() failed', e, s);
      _connecting = false;
      rethrow;
    }
  }

  @override
  Future<void> disconnect({bool force = false}) async {
    _manualDisconnect = force;
    _stopAppHeartbeat();

    try {
      _socket?.dispose();
    } catch (_) {}
    _socket = null;
  }

  @override
  void emit(String event, data) {
    if (isConnected) {
      _socket?.emit(event, data);
      return;
    }
    // Buffer until reconnection.
    _queue.add(_Queued(event, data, null, false, Duration.zero));
  }

  @override
  Future<dynamic> emitWithAck(
    String event,
    data, {
    Duration timeout = const Duration(seconds: 8),
  }) async {
    // If not connected, queue and resolve when connected (with the same timeout).
    if (!isConnected) {
      final completer = Completer<dynamic>();
      _queue.add(_Queued(event, data, (err, [ack]) {
        if (err != null) return completer.completeError(err);
        completer.complete(ack);
      }, true, timeout));
      return completer.future.timeout(timeout);
    }

    final completer = Completer<dynamic>();
    _emitWithAckInternal(event, data, (err, [ack]) {
      if (err != null) return completer.completeError(err);
      completer.complete(ack);
    }, timeout: timeout);
    return completer.future.timeout(timeout);
  }

  @override
  void on<T>(String event, void Function(T data) handler) {
    // We attach directly to socket.io; wrapper handles casting + error isolation.
    _socket?.on(event, (raw) {
      try {
        handler(raw as T);
      } catch (e, s) {
        logger('handler for "$event" threw', e, s);
      }
    });
  }

  @override
  void off(String event, [void Function(dynamic data)? handler]) {
    if (handler == null) {
      _socket?.off(event); // remove all handlers for event
    } else {
      _socket?.off(event, handler); // remove specific handler
    }
  }

  // -------------------- Internals --------------------

  void _setupCoreHandlers() {
    final s = _socket!;
    s.on('connect', (_) {
      logger('connected id=${s.id}');
      _connecting = false;
      _startAppHeartbeat();
      _flushQueue();
      _onConnect?.call();
    });

    s.on('connect_error', (err) {
      logger('connect_error: $err');
    });

    s.on('reconnect_attempt', (n) => logger('reconnect_attempt #$n'));
    s.on('reconnect', (n) {
      logger('reconnected after $n tries');
      _flushQueue();
    });

    s.on('disconnect', (reason) {
      logger('disconnected: $reason');
      _stopAppHeartbeat();
      if (_manualDisconnect) return; // respect manual off
      // socket.io will auto-reconnect due to options set above.
    });

    // Optional: listen to an auth error channel from your backend to refresh token.
    s.on('auth:error', (msg) async {
      logger('auth:error -> refreshing token and reconnecting');
      try {
        // Your token provider should refresh on demand if expired.
        await disconnect();
        await connect();
      } catch (e, st) {
        logger('reconnect after auth:error failed', e, st);
      }
    });
  }

  void _emitWithAckInternal(
    String event,
    dynamic data,
    void Function(Object? err, [dynamic ack]) done, {
    required Duration timeout,
  }) {
    bool finished = false;
    Timer? to;
    to = Timer(timeout, () {
      if (finished) return;
      finished = true;
      done(TimeoutException(
          'Ack timeout for "$event" after ${timeout.inMilliseconds}ms'));
    });

    try {
      _socket?.emitWithAck(event, data, ack: (dynamic response) {
        if (finished) return;
        finished = true;
        to?.cancel();
        done(null, response);
      });
    } catch (e) {
      if (finished) return;
      finished = true;
      to?.cancel();
      done(e);
    }
  }

  void _flushQueue() {
    if (!isConnected) return;
    for (final q in List<_Queued>.from(_queue)) {
      try {
        if (q.expectAck) {
          _emitWithAckInternal(
              q.event, q.data, (err, [ack]) => q.complete?.call(err, ack),
              timeout: q.timeout);
        } else {
          _socket?.emit(q.event, q.data);
          q.complete?.call(null);
        }
      } catch (e, s) {
        logger('flushQueue error', e, s);
        q.complete?.call(e);
      } finally {
        _queue.remove(q);
      }
    }
  }

  void _startAppHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(pingInterval, (_) {
      if (isConnected) {
        // App-level heartbeat (socket.io has engine ping already).
        _socket?.emit('app:heartbeat', {'t': DateTime.now().toIso8601String()});
      }
    });
  }

  void _stopAppHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  @override
  void onConnect(void Function() handler) {
    _onConnect = handler;
  }
}

class _Queued {
  final String event;
  final dynamic data;
  final void Function(Object? err, [dynamic ack])? complete;
  final bool expectAck;
  final Duration timeout;
  _Queued(this.event, this.data, this.complete, this.expectAck, this.timeout);
}
