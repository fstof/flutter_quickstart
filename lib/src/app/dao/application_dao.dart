import 'package:flutter_quick_start/src/core/index.dart';
import 'package:json_store/json_store.dart';

class ApplicationDao extends BaseDao {
  static const CURRENT_USER_KEY = 'currentUser';
  static const CURRENT_USER_VALUE_KEY = 'value';

  ApplicationDao({JsonStore storage}) : super(storage: storage);

  Future<void> storeCurrentUser(String user) async {
    try {
      await saveData(
        CURRENT_USER_KEY,
        {CURRENT_USER_VALUE_KEY: user},
      );
    } catch (e, stackTrace) {
      throw DaoException(
        message: 'failed to store current user',
        causedBy: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> removeCurrentUser() async {
    try {
      await deleteData(CURRENT_USER_KEY);
    } catch (e, stackTrace) {
      throw DaoException(
        message: 'failed to delete current user',
        causedBy: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<String> getCurrentUser() async {
    try {
      var userDataItem = await getData(CURRENT_USER_KEY);
      if (userDataItem.data != null) {
        return userDataItem.data[CURRENT_USER_VALUE_KEY];
      }
      return null;
    } catch (e, stackTrace) {
      throw DaoException(
        message: 'failed to get current user from storage',
        causedBy: e,
        stackTrace: stackTrace,
      );
    }
  }
}
