import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'notification_event.dart';
part 'notification_state.dart';

enum NotificationType { snackBar, dialog }
enum SnackBarType { fixed, floating }

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationState(time: DateTime.now()));

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
