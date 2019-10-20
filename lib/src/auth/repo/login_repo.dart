import 'package:flutter_quick_start/src/auth/api/login_api.dart';
import 'package:flutter_quick_start/src/core/exception/exceptions.dart';
import 'package:meta/meta.dart';

class LoginRepo {
  LoginApi _loginApi;
  LoginRepo({@required LoginApi loginApi}) : _loginApi = loginApi;

  Future<String> doLogin({String username, String password}) async {
    try {
      return await _loginApi.authenticate(
        username: username,
        password: password,
      );
    } on ApiException catch (e) {
      throw RepositoryException(message: 'api failed', causedBy: e);
    }
  }
}
