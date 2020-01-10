import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  @override
  NotificationState get initialState => NotificationState(time: DateTime.now());

  @override
  Stream<NotificationState> mapEventToState(
    NotificationEvent event,
  ) async* {
    yield NotificationState(
      title: event.title,
      message: event.message,
      type: event.type,
      duration: event.duration,
      snackBarType: event.snackBarType,
      actionString: event.actionString,
      actionCallback: event.actionCallback,
      time: event.time,
    );
  }
}

enum NotificationType { snackBar, dialog }
enum SnackBarType { fixed, floating }

class NotificationState extends Equatable {
  final String title;
  final String message;
  final NotificationType type;
  final Duration duration;
  final SnackBarType snackBarType;
  final String actionString;
  final Function actionCallback;
  final DateTime time;

  NotificationState({
    this.title,
    this.message,
    this.type = NotificationType.snackBar,
    this.duration = const Duration(seconds: 5),
    this.snackBarType = SnackBarType.floating,
    this.actionString,
    this.actionCallback,
    this.time,
  });

  @override
  List<Object> get props =>
      [title, message, type, duration, snackBarType, time];
}

class NotificationEvent extends Equatable {
  final String title;
  final String message;
  final NotificationType type;
  final Duration duration;
  final SnackBarType snackBarType;
  final String actionString;
  final Function actionCallback;
  final DateTime time;

  NotificationEvent({
    this.title,
    @required this.message,
    this.type = NotificationType.snackBar,
    this.duration = const Duration(seconds: 5),
    this.snackBarType = SnackBarType.fixed,
    this.actionString,
    this.actionCallback,
  })  : assert(message != null),
        this.time = DateTime.now();
  @override
  List<Object> get props =>
      [title, message, type, duration, snackBarType, time];
}
