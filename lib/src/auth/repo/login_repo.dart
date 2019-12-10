import 'package:flutter_quick_start/src/auth/api/login_api.dart';
import 'package:flutter_quick_start/src/core/exception/exceptions.dart';
import 'package:flutter_quick_start/src/core/storage/token_storage.dart';
import 'package:meta/meta.dart';

class LoginRepo {
  LoginApi _loginApi;
  TokenStorage _tokenStorage;

  LoginRepo({
    @required LoginApi loginApi,
    @required TokenStorage tokenStorage,
  })  : _loginApi = loginApi,
        _tokenStorage = tokenStorage;

  Future<String> doLogin({String username, String password}) async {
    try {
      final token = await _loginApi.authenticate(
        username: username,
        password: password,
      );
      if (token != null) {
        await _tokenStorage.setAccessToken(token);
      }
      return token;
    } on ApiException catch (e) {
      throw RepositoryException(message: 'api failed', causedBy: e);
    }
  }
}
