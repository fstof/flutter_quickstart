import 'dart:convert';

import 'package:flutter_quick_start/src/core/exception/exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:meta/meta.dart';

import '../storage/token_storage.dart';

abstract class BaseApi {
  final http.BaseClient _baseClient;
  final TokenStorage _tokenStorage;

  BaseApi({
    @required http.BaseClient baseClient,
    @required TokenStorage tokenStorage,
  })  : assert(baseClient != null && tokenStorage != null),
        this._baseClient = baseClient,
        this._tokenStorage = tokenStorage;

  Future<Map<String, String>> _addAuthHeader(
      Map<String, String> headers) async {
    final token = await _tokenStorage.getAccessToken();
    if (token != null) {
      headers['x-access-token'] = token;
    }
    return headers;
  }

  Future<http.Response> httpGet(
    String url, {
    Map<String, String> headers,
  }) async {
    Response response =
        await _baseClient.get(url, headers: await _addAuthHeader(headers));
    if (response.statusCode >= 300) {
      throw HttpException(
        message: response.reasonPhrase,
        statusCode: response.statusCode,
        body: response.body,
        response: response,
      );
    }
    return response;
  }

  Future<http.Response> httpPost(
    String url, {
    Map<String, String> headers,
    dynamic body,
    Encoding encoding,
  }) async {
    Response response = await _baseClient.post(
      url,
      headers: await _addAuthHeader(headers),
      body: body,
      encoding: encoding,
    );
    if (response.statusCode >= 300) {
      throw HttpException(
        message: response.reasonPhrase,
        statusCode: response.statusCode,
        body: response.body,
        response: response,
      );
    }
    return response;
  }

  Future<http.Response> httpPut(
    String url, {
    Map<String, String> headers,
    dynamic body,
    Encoding encoding,
  }) async {
    Response response = await _baseClient.put(
      url,
      headers: await _addAuthHeader(headers),
      body: body,
      encoding: encoding,
    );
    if (response.statusCode >= 300) {
      throw HttpException(
        message: response.reasonPhrase,
        statusCode: response.statusCode,
        body: response.body,
        response: response,
      );
    }
    return response;
  }
}
