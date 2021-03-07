import 'package:dio/dio.dart';

import '../../core/index.dart';

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
