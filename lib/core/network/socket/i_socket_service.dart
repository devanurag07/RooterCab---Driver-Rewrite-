// lib/core/network/socket/i_socket_service.dart

/// Abstraction for the socket so presentation/data code can import without
/// depending on a concrete implementation or a 3rd-party package.
abstract class ISocketService {
  /// Connect the socket. Safe to call multiple times; should no-op if already connected.
  Future<void> connect();

  /// Disconnect the socket. If [force] is true, prevents automatic reconnection.
  Future<void> disconnect({bool force = false});

  /// Whether the underlying socket is currently connected.
  bool get isConnected;

  /// Emit an event without expecting an acknowledgement.
  /// [event] is the channel name; [data] is JSON-serializable payload.
  void emit(String event, dynamic data);

  /// Emit an event and await an acknowledgement (with timeout).
  /// Returns the ack payload or throws [TimeoutException] / other error.
  Future<dynamic> emitWithAck(
    String event,
    dynamic data, {
    Duration timeout = const Duration(seconds: 8),
  });

  /// Attach a typed handler for a socket event channel.
  /// Example: on<Map<String, dynamic>>('ride:request', (m) { ... });
  void on<T>(String event, void Function(T data) handler);

  /// Remove a specific handler or all handlers for [event] if [handler] is null.
  void off(String event, [void Function(dynamic data)? handler]);

  void onConnect(void Function() handler);
}
