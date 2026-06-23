import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenManager {
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _secondPasswordTokenKey = 'second_password_token';
  static const _isRememberMeKey = 'is_remember_me';
  static const _savedUsernameKey = 'saved_username';
  static const _savedPasswordKey = 'saved_password';
  final _storage = const FlutterSecureStorage();

  Future<void> saveTokens({
    required String accessToken,
    required String? refreshToken,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);

    if (refreshToken != null) {
      await _storage.write(key: _refreshTokenKey, value: refreshToken);
    }
  }

  Future<void> saveSecondPasswordToken({
    required String secondPasswordToken,
  }) async {
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

  Future<void> saveLoginInfo({
    required String username,
    required String password,
    required bool isRememberMe,
  }) async {
    await _storage.write(key: _isRememberMeKey, value: isRememberMe.toString());
    if (isRememberMe) {
      await _storage.write(key: _savedUsernameKey, value: username);
      await _storage.write(key: _savedPasswordKey, value: password);
    } else {
      await clearLoginInfo();
    }
  }

  Future<Map<String, String?>> getLoginInfo() async {
    final isRememberMeStr = await _storage.read(key: _isRememberMeKey);
    final isRememberMe = isRememberMeStr == 'true';
    if (!isRememberMe) {
      return {'username': null, 'password': null, 'isRememberMe': 'false'};
    }
    final username = await _storage.read(key: _savedUsernameKey);
    final password = await _storage.read(key: _savedPasswordKey);
    return {
      'username': username,
      'password': password,
      'isRememberMe': 'true',
    };
  }

  Future<bool> getIsRememberMe() async {
    final isRememberMeStr = await _storage.read(key: _isRememberMeKey);
    return isRememberMeStr == 'true';
  }

  Future<void> clearLoginInfo() async {
    await _storage.delete(key: _savedUsernameKey);
    await _storage.delete(key: _savedPasswordKey);
  }
}
