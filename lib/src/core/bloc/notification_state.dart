part of 'notification_bloc.dart';

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
