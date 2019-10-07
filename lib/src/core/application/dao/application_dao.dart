import 'package:flutter_quick_start/src/core/exception/exceptions.dart';
import 'package:json_store/json_store.dart';

class ApplicationDao {
  static const CURRENT_USER_KEY = 'currentUser';
  static const CURRENT_USER_VALUE_KEY = 'value';

  JsonStore _storage;

  ApplicationDao({JsonStore storage}) : _storage = storage;

  Future<void> storeCurrentUser(String user) async {
    try {
      await _storage.setItem(
        CURRENT_USER_KEY,
        {CURRENT_USER_VALUE_KEY: user},
        encrypt: true,
      );
    } catch (e) {
      throw DaoException(
        message: 'failed to store current user',
        causedBy: e,
      );
    }
  }

  Future<void> removeCurrentUser() async {
    try {
      await _storage.deleteItem(CURRENT_USER_KEY);
    } catch (e) {
      throw DaoException(
        message: 'failed to delete current user',
        causedBy: e,
      );
    }
  }

  Future<String> getCurrentUser() async {
    try {
      var user = await _storage.getItem(CURRENT_USER_KEY);
      if (user != null) {
        return user[CURRENT_USER_VALUE_KEY];
      }
      return null;
    } catch (e) {
      throw DaoException(
        message: 'failed to get current user from storage',
        causedBy: e,
      );
    }
  }
}
