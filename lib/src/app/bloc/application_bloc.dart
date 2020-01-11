import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../auth/repo/user_repo.dart';
import '../../core/index.dart';
import 'application_event.dart';
import 'application_state.dart';

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
