import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_quick_start/src/auth/index.dart';
import 'package:flutter_quick_start/src/core/index.dart';
import 'package:meta/meta.dart';

class ApplicationBloc extends Bloc<ApplicationEvent, ApplicationState> {
  final _logger = getLogger();
  RemoteConfig _remoteConfig;
  AppConfig _appConfig;
  UserRepo _userRepo;
  ApplicationBloc({
    @required UserRepo userRepo,
    @required RemoteConfig remoteConfig,
    @required AppConfig appConfig,
  })  : this._userRepo = userRepo,
        this._remoteConfig = remoteConfig,
        this._appConfig = appConfig;

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
      await _remoteConfig.initialise(FlavorConfig.isProd());
      _appConfig.initialise();

      String user = await _userRepo.getCurrentUser();
      if (user != null) {
        yield ApplicationStateLoggedIn(user);
      } else {
        yield ApplicationStateLoggedOut();
      }
    } on DaoException catch (e, stackTrace) {
      _logger.w('storage failed', e, stackTrace);
      yield ApplicationStateLoggedOut();
    } catch (e, stackTrace) {
      _logger.e('Unknown error', e, stackTrace);
      yield ApplicationStateLoggedOut();
    }
  }

  Stream<ApplicationState> _mapApplicationEventUserLoggedInToState(
      ApplicationEventUserLoggedIn event) async* {
    try {
      await _userRepo.storeCurrentUser(event.loggedInUser);
      yield ApplicationStateLoggedIn(event.loggedInUser);
    } on DaoException catch (e) {
      _logger.w('storage failed', e);
      yield ApplicationStateLoggedOut();
    } catch (e) {
      _logger.e('unknown error', e);
      yield ApplicationStateLoggedOut();
    }
  }

  Stream<ApplicationState> _mapApplicationEventUserLoggedOutToState(
      ApplicationEventUserLogOut event) async* {
    try {
      await _userRepo.removeCurrentUser();
      yield ApplicationStateLoggedOut();
    } on DaoException catch (e) {
      _logger.w('storage failed', e);
      yield ApplicationStateLoggedOut();
    } catch (e) {
      _logger.e('unknown error', e);
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
