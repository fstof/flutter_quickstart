import 'package:meta/meta.dart';

import '../../app/index.dart';

class UserRepo {
  final ApplicationDao _applicationDao;
  UserRepo({@required ApplicationDao applicationDao})
      : this._applicationDao = applicationDao;

  Future<void> storeCurrentUser(String user) async {
    return _applicationDao.storeCurrentUser(user);
  }

  Future<void> removeCurrentUser() async {
    return _applicationDao.removeCurrentUser();
  }

  Future<String> getCurrentUser() async {
    return _applicationDao.getCurrentUser();
  }
}
