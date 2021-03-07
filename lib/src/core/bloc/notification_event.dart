part of 'notification_bloc.dart';

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
