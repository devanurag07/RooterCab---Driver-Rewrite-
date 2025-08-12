// core/network/api_client.dart
abstract class ApiClient {
  Future<Map<String, dynamic>> get(String path, {Map<String, dynamic>? query});
  Future<Map<String, dynamic>> post(String path,
      {Object? body, Map<String, dynamic>? query});
  Future<Map<String, dynamic>> put(String path, {Object? body});
  Future<Map<String, dynamic>> patch(String path, {Object? body});
  Future<void> delete(String path, {Object? body});
}
