import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenManager {
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _secondPasswordTokenKey = 'second_password_token';
  final _storage = const FlutterSecureStorage();

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  Future<void> saveSecondPasswordToken({required String secondPasswordToken}) async {
    await _storage.write(
      key: _secondPasswordTokenKey,
      value: secondPasswordToken,
    );
  }

  Future<String?> getAccessToken() => _storage.read(key: _accessTokenKey);
  Future<String?> getRefreshToken() => _storage.read(key: _refreshTokenKey);
  Future<String?> getSecondPasswordToken() =>
      _storage.read(key: _secondPasswordTokenKey);

  Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _secondPasswordTokenKey);
  }

  Future<void> removeSecondPasswordToken() async {
    await _storage.delete(key: _secondPasswordTokenKey);
  }
}
