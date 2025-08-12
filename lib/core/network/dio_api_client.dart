// core/network/dio_api_client.dart
import 'package:dio/dio.dart';
import 'api_client.dart';
import 'errors.dart';

class DioApiClient implements ApiClient {
  final Dio _dio;

  DioApiClient._(this._dio);

  factory DioApiClient.create({
    required String baseUrl,
    required Interceptor authInterceptor,
    Interceptor? logInterceptor,
  }) {
    final dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      responseType: ResponseType.json,
      headers: {'Content-Type': 'application/json'},
    ));

    dio.interceptors.add(authInterceptor);
    if (logInterceptor != null) dio.interceptors.add(logInterceptor);

    return DioApiClient._(dio);
  }

  @override
  Future<Map<String, dynamic>> get(String path,
      {Map<String, dynamic>? query}) async {
    try {
      final res = await _dio.get(path, queryParameters: query);
      return (res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> post(String path,
      {Object? body, Map<String, dynamic>? query}) async {
    try {
      final res = await _dio.post(path, data: body, queryParameters: query);
      return (res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> put(String path, {Object? body}) async {
    try {
      final res = await _dio.put(path, data: body);
      return (res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> patch(String path, {Object? body}) async {
    try {
      final res = await _dio.patch(path, data: body);
      return (res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  @override
  Future<void> delete(String path, {Object? body}) async {
    try {
      await _dio.delete(path, data: body);
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }
}
