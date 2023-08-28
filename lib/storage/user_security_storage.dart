import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class UserSecurityStorage {
  static final _storage = FlutterSecureStorage();
  static const _email = "email";
  static const _name = "name";
  static const _token = "token";


  static Future setUserEmail(String email) async => {
    await _storage.write(key: _email, value: email)
  };
  static Future setUsername(String name) async => {
    await _storage.write(key: _email, value: name)
  };
  static Future setToken(String token) async => {
    await _storage.write(key: _token, value: token)
  };
  static Future<String?> getToken() async => await _storage.read(key: _token);
  static Future<String?> getEmail() async => await _storage.read(key: _email);
  static Future<String?> getName() async => await _storage.read(key: _name);
}