import 'dart:convert';

import 'package:flutter_quick_start/src/core/api/base_api.dart';
import 'package:flutter_quick_start/src/core/exception/exceptions.dart';
import 'package:flutter_quick_start/src/core/storage/token_storage.dart';
import 'package:http/http.dart';

class LoginApi extends BaseApi {
  LoginApi({BaseClient baseClient, TokenStorage tokenStorage})
      : super(baseClient: baseClient, tokenStorage: tokenStorage);

  Future<bool> authenticate({String username, String password}) async {
    if (username == 'error') {
      throw ApiException(message: 'Error: 400', causedBy: 'bad username');
    }
    try {
      Response response = await super.httpPost(
        'https://jsonplaceholder.typicode.com/auth/v1/login',
        headers: {
          'content-type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );
      return response.body !=
          null; // you probably want to parse this body to an actual object
    } on HttpException catch (e) {
      if (e.statusCode == 401 || e.statusCode == 403) {
        return false;
      } else {
        throw ApiException(message: 'unexpected response', causedBy: e);
      }
    } catch (e) {
      throw ApiException(message: 'something bad happened', causedBy: e);
    }
  }
}
