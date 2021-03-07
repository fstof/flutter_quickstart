import 'package:firebase_messaging/firebase_messaging.dart';

import '../index.dart';

class PushHandler {
  final _logger = getLogger();

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
    _logger.i('PushHandler created');
  }

  void setupPush() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Got a message onMessageOpenedApp');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    FirebaseMessaging.onBackgroundMessage((message) async {
      print('Got a message onBackgroundMessage');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    // _firebaseMessaging.configure(
    //   onMessage: _handleOnMessage,
    //   onResume: _handleOnResume,
    //   onLaunch: _handleOnLaunch,
    // );
  }

  Future<void> _handleOnMessage(Map<String, dynamic> message) async {
    _logger.i('Message received onMessage ${message.toString()}');
    if (message['data'] == null) {
      message = {'data': message};
    }
    _handleMessage(message);
  }

  Future<void> _handleOnResume(Map<String, dynamic> message) async {
    _logger.i('Message received onResume ${message.toString()}');
    if (message['data'] == null) {
      message = {'data': message};
    }
    _handleMessage(message);
  }

  Future<void> _handleOnLaunch(Map<String, dynamic> message) async {
    _logger.i('Message received onLaunch ${message.toString()}');
    if (message['data'] == null) {
      message = {'data': message};
    }
    _handleMessage(message);
  }

  void _handleMessage(Map<String, dynamic> message) {
    _notificationBloc.add(
      NotificationEvent(
        title: message['notification']['title'],
        message: message['notification']['body'],
        snackBarType: SnackBarType.floating,
      ),
    );
  }
}
