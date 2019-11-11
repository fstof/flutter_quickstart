import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_quick_start/src/auth/api/login_api.dart';
import 'package:flutter_quick_start/src/core/core.dart';
import 'package:flutter_quick_start/src/core/exception/exceptions.dart';
import 'package:meta/meta.dart';

class LoginRepo {
  final _logger = getLogger();

  FlutterAppAuth _appAuth;
  LoginApi _loginApi;
  LoginRepo({
    @required LoginApi loginApi,
    @required FlutterAppAuth appAuth,
  })  : _loginApi = loginApi,
        _appAuth = appAuth;

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

  Future<AuthorizationTokenResponse> initiateOAuth() async {
    try {
      var result = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          'native.code',
          'dev.stofberg.quickstart://oauth-callback',
          discoveryUrl:
              'https://demo.identityserver.io/.well-known/openid-configuration',
          scopes: ['openid', 'profile', 'email', 'api', 'offline_access'],
          loginHint: 'bob',
        ),
      );
      _logger.d(result);
      return result;
    } catch (e) {
      _logger.e('error authing', e);
      throw RepositoryException(message: 'oauth failed', causedBy: e);
    }
  }
}
