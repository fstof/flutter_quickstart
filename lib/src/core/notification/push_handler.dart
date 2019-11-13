import 'package:firebase_messaging/firebase_messaging.dart';

import '../logging/logger.dart';
import 'notification_bloc.dart';

class PushHandler {
  final _log = getLogger();

  static PushHandler _instance;

  final NotificationBloc _notificationBloc;
  final FirebaseMessaging _firebaseMessaging;

  factory PushHandler(
    NotificationBloc notificationBloc,
    FirebaseMessaging firebaseMessaging,
  ) {
    if (_instance == null) {
      _instance = PushHandler._private(
        notificationBloc,
        firebaseMessaging,
      );
    }
    return _instance;
  }

  PushHandler._private(
    NotificationBloc notificationBloc,
    FirebaseMessaging firebaseMessaging,
  )   
  // : _context = context,
  : _notificationBloc = notificationBloc,
        _firebaseMessaging = firebaseMessaging {
    _log.i('PushHandler created');
  }

  void setupPush() {
    _firebaseMessaging.configure(
      onMessage: _handleOnMessage,
      onResume: _handleOnResume,
      onLaunch: _handleOnLaunch,
    );
  }

  Future<void> _handleOnMessage(Map<String, dynamic> message) async {
    _log.i('Message received onMessage ${message.toString()}');
    if (message['data'] == null) {
      message = {'data': message};
    }
    _handleMessage(message);
  }

  Future<void> _handleOnResume(Map<String, dynamic> message) async {
    _log.i('Message received onResume ${message.toString()}');
    if (message['data'] == null) {
      message = {'data': message};
    }
    _handleMessage(message);
  }

  Future<void> _handleOnLaunch(Map<String, dynamic> message) async {
    _log.i('Message received onLaunch ${message.toString()}');
    if (message['data'] == null) {
      message = {'data': message};
    }
    _handleMessage(message);
  }

  void _handleMessage(Map<String, dynamic> message) {
    _notificationBloc.dispatch(
      NotificationEvent(
        title: message['notification']['title'],
        message: message['notification']['body'],
        snackBarType: SnackBarType.floating,
      ),
    );
  }
}
