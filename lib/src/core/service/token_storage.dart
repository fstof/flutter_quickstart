import 'package:json_store/json_store.dart';
import 'package:meta/meta.dart';

class TokenStorage {
  static TokenStorage _instance;

  JsonStore _storage;
  static const _key = 'access_token';
  static const _value = 'value';

  TokenStorage._createInstance(JsonStore database) {
    _storage = database;
  }

  factory TokenStorage({@required JsonStore localStorage}) {
    if (_instance == null) {
      _instance = TokenStorage._createInstance(localStorage);
    }
    return _instance;
  }

  Future<void> setAccessToken(String token) {
    return _storage.setItem(
      _key,
      {_value: token},
      encrypt: true,
    );
  }

  Future<String> getAccessToken() async {
    final Map<String, dynamic> val = await _storage.getItem(_key);
    if (val != null) {
      return val[_value];
    }
    return null;
  }
}
