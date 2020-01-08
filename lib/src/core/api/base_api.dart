import 'package:dio/dio.dart';

abstract class BaseApi {
  final Dio _dio;

  BaseApi(this._dio);

  Future<dynamic> httpGet(
    String url, {
    Map<String, String> headers,
  }) async {
    Response response = await _dio.get(
      url,
      options: Options(headers: headers),
    );
    return response.data;
  }

  Future<dynamic> httpPost(
    String url, {
    Map<String, String> headers,
    dynamic body,
  }) async {
    Response response = await _dio.post(
      url,
      data: body,
      options: Options(headers: headers),
    );
    return response.data;
  }

  Future<dynamic> httpPut(
    String url, {
    Map<String, String> headers,
    dynamic body,
  }) async {
    Response response = await _dio.put(
      url,
      data: body,
      options: Options(headers: headers),
    );
    return response.data;
  }
}
