// core/network/interceptors/auth_interceptor.dart
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:uber_clone_x/core/network/token/token_store.dart';
import 'package:uber_clone_x/core/utils/naviation_utils.dart';

class AuthInterceptor extends Interceptor {
  final TokenStore tokenStore;
  final Dio dio; // a bare instance used only for refresh call (no loops)

  bool _refreshing = false;
  final List<QueuedInterceptorRequest> _queue = [];

  AuthInterceptor({required this.tokenStore, required this.dio});

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await tokenStore.readAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // If unauthorized, try refresh once
    if (err.response?.statusCode == 401) {
      final refresh = await tokenStore.readRefreshToken();
      if (refresh == null) {
        // No refresh token available, clear storage and navigate to login
        await tokenStore.clear();
        navigateToLogin();
        return handler.next(err);
      }

      // queue pending requests to retry after refresh
      _queue.add(QueuedInterceptorRequest(
        requestOptions: err.requestOptions,
        completer: Completer<Response>(),
        handler: handler,
      ));

      if (_refreshing) return; // already refreshing, queued

      _refreshing = true;
      try {
        final newTokens = await _refreshToken(refresh);
        await tokenStore.writeTokens(
            access: newTokens.access, refresh: newTokens.refresh);

        // retry queued requests with new token
        for (final q in _queue) {
          final opts = q.requestOptions
            ..headers['Authorization'] = 'Bearer ${newTokens.access}';
          try {
            final r = await dio.fetch(opts);
            q.completer.complete(r);
            q.handler.resolve(r);
          } catch (e) {
            q.completer.completeError(e);
            q.handler.next(e as DioException);
          }
        }
      } catch (_) {
        await tokenStore.clear();
        // Navigate to login screen on auth failure
        navigateToLogin();
        for (final q in _queue) {
          q.handler.next(err); // propagate original 401
        }
      } finally {
        _queue.clear();
        _refreshing = false;
      }
      return; // handled
    }
    handler.next(err);
  }

  Future<_Tokens> _refreshToken(String refresh) async {
    // NOTE: make sure you use a base Dio with NO AuthInterceptor to avoid loops
    final res =
        await dio.post('/auth/refresh', data: {'refreshToken': refresh});
    final data = res.data as Map<String, dynamic>;
    return _Tokens(data['accessToken'] as String,
        data['refreshToken'] as String? ?? refresh);
  }
}

class QueuedInterceptorRequest {
  final RequestOptions requestOptions;
  final Completer<Response> completer;
  final ErrorInterceptorHandler handler;
  QueuedInterceptorRequest(
      {required this.requestOptions,
      required this.completer,
      required this.handler});
}

class _Tokens {
  final String access;
  final String refresh;
  _Tokens(this.access, this.refresh);
}
