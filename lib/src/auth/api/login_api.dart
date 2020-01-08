import 'package:dio/dio.dart';
import 'package:flutter_quick_start/src/core/api/base_api.dart';
import 'package:flutter_quick_start/src/core/core.dart';
import 'package:flutter_quick_start/src/core/exception/exceptions.dart';

class LoginApi extends BaseApi {
  LoginApi(Dio _dio) : super(_dio);

  Future<String> authenticate({String username, String password}) async {
    if (username == 'error') {
      throw ApiException(message: 'Error: 400', causedBy: 'bad username');
    }
    try {
      var response = await super.httpPost(
        // '${sl<AppConfig>().apiBaseUrl}/api/login',
        'https://jsonplaceholder.typicode.com/posts',
        body: {
          'email': username,
          'password': password,
        },
      );

      var body = response;
      // Maybe parse to some kind of class representing the full response body
      // return body['token'];
      return body['id'].toString();
    } catch (e) {
      throw ApiException(message: 'something bad happened', causedBy: e);
    }
  }
}
