import "token_store.dart";

class SecureTokenStore extends TokenStore {
  SecureTokenStore(super.sharedPreferences);

  @override
  Future<String?> readAccessToken() async {
    return sharedPreferences.getString("access_token");
  }

  @override
  Future<String?> readRefreshToken() async {
    return sharedPreferences.getString("refresh_token");
  }

  @override
  Future<void> writeTokens(
      {required String access, required String refresh}) async {
    await sharedPreferences.setString("access_token", access);
    await sharedPreferences.setString("refresh_token", refresh);
  }

  @override
  Future<void> clear() async {
    await sharedPreferences.remove("access_token");
    await sharedPreferences.remove("refresh_token");
  }
}
