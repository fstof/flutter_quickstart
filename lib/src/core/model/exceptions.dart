abstract class BaseException implements Exception {
  final String message;
  final causedBy;
  final StackTrace stackTrace;
  BaseException({this.message, this.causedBy, this.stackTrace});

  @override
  String toString() {
    return '\n  ${super.toString()}: [message]: $message\n[caused by]: ${causedBy.toString()}';
  }
}

class DaoException extends BaseException {
  DaoException({message, causedBy, stackTrace})
      : super(message: message, causedBy: causedBy, stackTrace: stackTrace);
}

class ApiException extends BaseException {
  ApiException({message, causedBy, stackTrace})
      : super(message: message, causedBy: causedBy, stackTrace: stackTrace);
}

// class HttpException extends BaseException {
//   Response response;
//   int statusCode;
//   String body;
//   HttpException({this.response, this.statusCode, this.body, message, causedBy, stackTrace})
//       : super(message: message, causedBy: causedBy, stackTrace: stackTrace);
//   @override
//   String toString() {
//     return '${super.toString()}\n[status]: $statusCode\n[body]: $body'; // printing out $body might be a bit too much change as you like
//   }
// }

class RepositoryException extends BaseException {
  RepositoryException({message, causedBy, stackTrace})
      : super(message: message, causedBy: causedBy, stackTrace: stackTrace);
}

class AuthException extends BaseException {
  AuthException({message, causedBy, stackTrace})
      : super(message: message, causedBy: causedBy, stackTrace: stackTrace);
}
