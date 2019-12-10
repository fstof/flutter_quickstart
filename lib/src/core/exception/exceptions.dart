

abstract class BaseException implements Exception {
  final String message;
  final causedBy;
  BaseException({this.message, this.causedBy});

  @override
  String toString() {
    return '\n  ${super.toString()}: [message]: $message\n[caused by]: ${causedBy.toString()}';
  }
}

class DaoException extends BaseException {
  DaoException({message, causedBy})
      : super(message: message, causedBy: causedBy);
}

class ApiException extends BaseException {
  ApiException({message, causedBy})
      : super(message: message, causedBy: causedBy);
}

// class HttpException extends BaseException {
//   Response response;
//   int statusCode;
//   String body;
//   HttpException({this.response, this.statusCode, this.body, message, causedBy})
//       : super(message: message, causedBy: causedBy);
//   @override
//   String toString() {
//     return '${super.toString()}\n[status]: $statusCode\n[body]: $body'; // printing out $body might be a bit too much change as you like
//   }
// }

class RepositoryException extends BaseException {
  RepositoryException({message, causedBy})
      : super(message: message, causedBy: causedBy);
}

class AuthException extends BaseException {
  AuthException({message, causedBy})
      : super(message: message, causedBy: causedBy);
}
