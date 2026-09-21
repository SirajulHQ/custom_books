import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  TokenStorage._();
  static final TokenStorage instance = TokenStorage._();

  static const _accessKey = 'auth_access_token';
  static const _refreshKey = 'auth_refresh_token';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveTokens({
    required String access,
    required String refresh,
  }) async {
    await Future.wait([
      _storage.write(key: _accessKey, value: access),
      _storage.write(key: _refreshKey, value: refresh),
    ]);
  }

  Future<void> saveAccessToken(String access) async {
    await _storage.write(key: _accessKey, value: access);
  }

  Future<String?> readAccessToken() => _storage.read(key: _accessKey);

  Future<String?> readRefreshToken() => _storage.read(key: _refreshKey);

  Future<void> clear() async {
    await Future.wait([
      _storage.delete(key: _accessKey),
      _storage.delete(key: _refreshKey),
    ]);
  }
}
