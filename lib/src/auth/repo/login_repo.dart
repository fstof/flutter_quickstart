import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:meta/meta.dart';

import '../../core/index.dart';
import '../api/login_api.dart';

class LoginRepo {
  final _logger = getLogger();

  FlutterAppAuth _appAuth;
  LoginApi _loginApi;
  TokenStorage _tokenStorage;

  LoginRepo({
    @required LoginApi loginApi,
    @required TokenStorage tokenStorage,
    @required FlutterAppAuth appAuth,
  })  : _loginApi = loginApi,
        _tokenStorage = tokenStorage,
        _appAuth = appAuth;

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
