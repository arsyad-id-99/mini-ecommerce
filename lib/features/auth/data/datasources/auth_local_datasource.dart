import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;
  static const cachedTokenKey = 'CACHED_TOKEN';

  AuthLocalDataSourceImpl(this.secureStorage);

  @override
  Future<void> saveToken(String token) async {
    await secureStorage.write(key: cachedTokenKey, value: token);
  }

  @override
  Future<String?> getToken() async {
    return secureStorage.read(key: cachedTokenKey);
  }

  @override
  Future<void> clearToken() async {
    await secureStorage.delete(key: cachedTokenKey);
  }
}
