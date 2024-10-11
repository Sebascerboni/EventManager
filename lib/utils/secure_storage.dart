import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHelper {
  static const _storage = FlutterSecureStorage();

  // Singleton pattern implementation
  static final SecureStorageHelper _instance = SecureStorageHelper._internal();

  factory SecureStorageHelper() {
    return _instance;
  }

  SecureStorageHelper._internal();

  Future<void> storeValue(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      throw Exception('Error storing value for key $key: $e');
    }
  }

  Future<String?> getValue(String key) async {
    try {
      final String? value = await _storage.read(key: key);
      return value;
    } catch (e) {
      throw Exception('Error retrieving value for key $key: $e');
    }
  }
}