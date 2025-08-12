// core/storage/token_store.dart
import 'package:shared_preferences/shared_preferences.dart';

abstract class TokenStore {
  final SharedPreferences sharedPreferences;
  TokenStore(this.sharedPreferences);

  Future<String?> readAccessToken();
  Future<String?> readRefreshToken();
  Future<void> writeTokens({required String access, required String refresh});
  Future<void> clear();
}
