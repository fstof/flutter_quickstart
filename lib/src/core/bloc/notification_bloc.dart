import 'package:bloc/bloc.dart';

import 'notification_event.dart';
import 'notification_state.dart';

enum NotificationType { snackBar, dialog }
enum SnackBarType { fixed, floating }

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
