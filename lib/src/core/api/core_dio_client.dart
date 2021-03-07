import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:meta/meta.dart';

import '../index.dart';

class CoreDioClient with DioMixin implements Dio {
  final _logger = getLogger();
  final TokenStorage _tokenStorage;

  CoreDioClient({@required TokenStorage tokenStorage})
      : this._tokenStorage = tokenStorage {
    httpClientAdapter = DefaultHttpClientAdapter();
    options = BaseOptions();

    interceptors.add(InterceptorsWrapper(
      onRequest: (RequestOptions options) async {
        _logger.i('onRequest ${options.toString()}');
        var token = await _tokenStorage.getAccessToken();
        if (token != null) {
          _logger.i('adding access token to headers: $token');
          options.headers['token'] = token;
        }
        return options;
      },
    ));
    interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
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
    HttpMethod method = HttpMethod.Get;

    if (options.method == 'GET') {
      method = HttpMethod.Get;
    } else if (options.method == 'POST') {
      method = HttpMethod.Post;
    } else if (options.method == 'HEAD') {
      method = HttpMethod.Head;
    } else if (options.method == 'PUT') {
      method = HttpMethod.Put;
    } else if (options.method == 'DELETE') {
      method = HttpMethod.Delete;
    } else if (options.method == 'CONNECT') {
      method = HttpMethod.Connect;
    } else if (options.method == 'OPTIONS') {
      method = HttpMethod.Options;
    } else if (options.method == 'PATCH') {
      method = HttpMethod.Patch;
    } else if (options.method == 'TRACE') {
      method = HttpMethod.Trace;
    }
    final HttpMetric metric =
        sl<FirebasePerformance>().newHttpMetric(path, method);

    await metric.start();
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

      metric
        ..requestPayloadSize =
            int.parse(response?.request?.headers['content-length'] ?? '0')
        ..responsePayloadSize =
            int.parse(response?.headers?.value('content-length') ?? '0')
        ..responseContentType = response?.headers?.value('content-type')
        ..httpResponseCode = response.statusCode;

      return response;
    } on DioError catch (dioError) {
      _logger.e(
        '[API_ERROR] error in ${DateTime.now().millisecondsSinceEpoch - start} ms. An Exception occurred when calling $path',
        dioError,
      );
      await sl<FirebaseCrashlytics>().recordError(
        dioError,
        StackTrace.fromString('No Stack available'),
      );
      rethrow;
    } catch (error) {
      _logger.e(
        '[API_ERROR] error in ${DateTime.now().millisecondsSinceEpoch - start} ms. An Exception occurred when calling $path',
        error,
      );
      await sl<FirebaseCrashlytics>().recordError(
        error,
        error['stacktrace'] ?? StackTrace.fromString('No Stack available'),
      );
      rethrow;
    } finally {
      await metric.stop();
    }
  }
}
