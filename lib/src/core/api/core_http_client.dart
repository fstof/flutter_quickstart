import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:http/http.dart';

import '../core.dart';

class CoreHttpClient extends BaseClient {
  final _log = getLogger();
  CoreHttpClient(this._inner);

  final Client _inner;

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    HttpMethod method = HttpMethod.Get;

    if (request.method == 'GET') {
      method = HttpMethod.Get;
    } else if (request.method == 'POST') {
      method = HttpMethod.Post;
    } else if (request.method == 'HEAD') {
      method = HttpMethod.Head;
    } else if (request.method == 'PUT') {
      method = HttpMethod.Put;
    } else if (request.method == 'DELETE') {
      method = HttpMethod.Delete;
    } else if (request.method == 'CONNECT') {
      method = HttpMethod.Connect;
    } else if (request.method == 'OPTIONS') {
      method = HttpMethod.Options;
    } else if (request.method == 'PATCH') {
      method = HttpMethod.Patch;
    } else if (request.method == 'TRACE') {
      method = HttpMethod.Trace;
    }

    final HttpMetric metric =
        sl<FirebasePerformance>().newHttpMetric(request.url.toString(), method);

    await metric.start();
    int start = DateTime.now().millisecondsSinceEpoch;

    StreamedResponse response;
    try {
      _log.d('[API_REQUEST] sending request to: ${request.toString()}');
      response = await _inner.send(request);

      _log.d(
          '[API_RESPONSE] got [${response.statusCode}] response in ${DateTime.now().millisecondsSinceEpoch - start} ms, with headers: ${response.headers.toString()}');
      metric
        ..responsePayloadSize = response.contentLength ?? 0
        ..responseContentType = response.headers['content-type']
        ..requestPayloadSize = request.contentLength
        ..httpResponseCode = response.statusCode;

      if (response.statusCode == 401 || response.statusCode == 403) {
        _log.w(
          '[API_ERROR] in ${DateTime.now().millisecondsSinceEpoch - start} ms: Auth error when calling ${request.url.toString()} - [${response.statusCode}]',
        );
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        _log.w(
          '[API_ERROR] in ${DateTime.now().millisecondsSinceEpoch - start} ms: Input error: ${request.url.toString()} - [${response.statusCode}]',
        );
      } else if (response.statusCode >= 500) {
        _log.e(
          '[API_ERROR] in ${DateTime.now().millisecondsSinceEpoch - start} ms: A backend failure occurred when calling ${request.url.toString()} - [${response.statusCode}]',
        );
        await sl<Crashlytics>().recordError(
          Exception('Backend Failure'),
          StackTrace.fromString('No Stack available'),
          context: 'CoreHttpClient',
        );
      }
      return response;
    } catch (error) {
      _log.e(
        '[API_ERROR] error in ${DateTime.now().millisecondsSinceEpoch - start} ms. An Exception occurred when calling ${request.url.toString()}}',
        error,
      );
      await sl<Crashlytics>().recordError(
        error,
        StackTrace.fromString('No Stack available'),
        context: 'CoreHttpClient',
      );

      rethrow;
    } finally {
      await metric.stop();
    }
  }
}
