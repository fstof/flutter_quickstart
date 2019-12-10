import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_quick_start/src/core/storage/token_storage.dart';
import 'package:meta/meta.dart';

import '../core.dart';

class CoreDioClient with DioMixin implements Dio {
  final _log = getLogger();
  final TokenStorage _tokenStorage;

  CoreDioClient({@required TokenStorage tokenStorage})
      : this._tokenStorage = tokenStorage {
    httpClientAdapter = DefaultHttpClientAdapter();
    options = BaseOptions();

    interceptors.add(InterceptorsWrapper(
      onRequest: (RequestOptions options) async {
        _log.i('onRequest ${options.toString()}');
        var token = await _tokenStorage.getAccessToken();
        if (token != null) {
          _log.i('adding access token to headers: $token');
          options.headers['token'] = token;
        }
        return options;
      },
    ));
    interceptors.add(LogInterceptor(
      request: true,
      requestHeader: false,
      requestBody: false,
      responseHeader: true,
      responseBody: false,
      error: true,
      // logPrint: _log.i,
    ));
  }

  @override
  Future<Response<T>> request<T>(
    String path, {
    data,
    Map<String, dynamic> queryParameters,
    CancelToken cancelToken,
    Options options,
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  }) async {
    // HttpMethod method = HttpMethod.Get;

    // if (options.method == 'GET') {
    //   method = HttpMethod.Get;
    // } else if (options.method == 'POST') {
    //   method = HttpMethod.Post;
    // } else if (options.method == 'HEAD') {
    //   method = HttpMethod.Head;
    // } else if (options.method == 'PUT') {
    //   method = HttpMethod.Put;
    // } else if (options.method == 'DELETE') {
    //   method = HttpMethod.Delete;
    // } else if (options.method == 'CONNECT') {
    //   method = HttpMethod.Connect;
    // } else if (options.method == 'OPTIONS') {
    //   method = HttpMethod.Options;
    // } else if (options.method == 'PATCH') {
    //   method = HttpMethod.Patch;
    // } else if (options.method == 'TRACE') {
    //   method = HttpMethod.Trace;
    // }
    // final HttpMetric metric =
    //     sl<FirebasePerformance>().newHttpMetric(path, method);

    // await metric.start();
    int start = DateTime.now().millisecondsSinceEpoch;
    try {
      Response response = await super.request<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      // metric
      //   ..requestPayloadSize = 1
      //   ..responsePayloadSize = int.parse(response.headers.value('content-length') ?? '0')
      //   ..responseContentType = response.headers.value('content-type')
      //   ..httpResponseCode = response.statusCode;

      return response;
    } catch (error) {
      _log.e(
        '[API_ERROR] error in ${DateTime.now().millisecondsSinceEpoch - start} ms. An Exception occurred when calling $path',
        error,
      );
      await sl<Crashlytics>().recordError(
        error,
        error['stacktrace'] ?? StackTrace.fromString('No Stack available'),
        context: 'CoreDioClient',
      );

      rethrow;
    } finally {
      // await metric.stop();
    }
  }
}
