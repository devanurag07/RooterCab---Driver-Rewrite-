// core/network/errors.dart
sealed class ApiException implements Exception {
  final String message;
  final int? statusCode;
  const ApiException(this.message, {this.statusCode});
}

final class NetworkException extends ApiException {
  const NetworkException(super.m);
}

final class TimeoutExceptionX extends ApiException {
  const TimeoutExceptionX(super.m);
}

final class UnauthorizedException extends ApiException {
  const UnauthorizedException(super.m, {super.statusCode = 401});
}

final class ServerException extends ApiException {
  const ServerException(super.m, {super.statusCode});
}

// optional: map DioError/Response -> ApiException
ApiException mapDioError(Object e) {
  // keep concise and safe
  // ... map to types above
  return ServerException('Unexpected error');
}
