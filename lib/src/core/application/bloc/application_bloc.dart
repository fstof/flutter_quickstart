import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_quick_start/src/core/core.dart';
import 'package:meta/meta.dart';

import '../../exception/exceptions.dart';
import '../dao/application_dao.dart';

class ApplicationBloc extends Bloc<ApplicationEvent, ApplicationState> {
  final logger = getLogger();

  ApplicationDao _applicationDao;
  ApplicationBloc({@required ApplicationDao applicationDao})
      : this._applicationDao = applicationDao;

  @override
  ApplicationState get initialState => ApplicationStateLoggedOut();

  @override
  Stream<ApplicationState> mapEventToState(ApplicationEvent event) async* {
    yield ApplicationStateAppLoading();
    if (event is ApplicationEventAppStarted) {
      yield* _mapApplicationEventAppStartedToState(event);
    } else if (event is ApplicationEventUserLoggedIn) {
      yield* _mapApplicationEventUserLoggedInToState(event);
    } else if (event is ApplicationEventUserLogOut) {
      yield* _mapApplicationEventUserLoggedOutToState(event);
    } else {
      yield* _mapApplicationEventUserLoggedOutToState(event);
    }
  }

  Stream<ApplicationState> _mapApplicationEventAppStartedToState(
      ApplicationEventAppStarted event) async* {
    try {
      String user = await _applicationDao.getCurrentUser();
      if (user != null) {
        yield ApplicationStateLoggedIn(user);
      } else {
        yield ApplicationStateLoggedOut();
      }
    } on DaoException catch (e) {
      logger.w('storage failed', e);
      yield ApplicationStateLoggedOut();
    } catch (e) {
      logger.e('Unknown error', e);
      yield ApplicationStateLoggedOut();
    }
  }

  Stream<ApplicationState> _mapApplicationEventUserLoggedInToState(
      ApplicationEventUserLoggedIn event) async* {
    try {
      await _applicationDao.storeCurrentUser(event.loggedInUser);
      yield ApplicationStateLoggedIn(event.loggedInUser);
    } on DaoException catch (e) {
      logger.w('storage failed', e);
      yield ApplicationStateLoggedOut();
    } catch (e) {
      logger.e('unknown error', e);
      yield ApplicationStateLoggedOut();
    }
  }

  Stream<ApplicationState> _mapApplicationEventUserLoggedOutToState(
      ApplicationEventUserLogOut event) async* {
    try {
      await _applicationDao.removeCurrentUser();
      yield ApplicationStateLoggedOut();
    } on DaoException catch (e) {
      logger.w('storage failed', e);
      yield ApplicationStateLoggedOut();
    } catch (e) {
      logger.e('unknown error', e);
      yield ApplicationStateLoggedOut();
    }
  }
}

abstract class ApplicationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ApplicationEventAppStarted extends ApplicationEvent {}

class ApplicationEventUserLoggedIn extends ApplicationEvent {
  final loggedInUser;

  ApplicationEventUserLoggedIn(this.loggedInUser);

  @override
  List<Object> get props => [loggedInUser];
}

class ApplicationEventUserLogOut extends ApplicationEvent {}

abstract class ApplicationState extends Equatable {
  @override
  List<Object> get props => [];
}

class ApplicationStateAppLoading extends ApplicationState {}

class ApplicationStateLoggedOut extends ApplicationState {}

class ApplicationStateLoggedIn extends ApplicationState {
  final loggedInUser;

  ApplicationStateLoggedIn(this.loggedInUser);

  @override
  List<Object> get props => [loggedInUser];
}
