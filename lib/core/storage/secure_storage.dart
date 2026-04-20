import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  const SecureStorage._();
  static final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static FlutterSecureStorage get storage => _storage;

  static Future<void> setSecureData(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  static Future<String?> getSecureData(String key) async {
    String value = await _storage.read(key: key) ?? '';
    return value;
  }

  static Future<void> deleteSecureData(String key) async {
    await _storage.delete(key: key);
  }
}
