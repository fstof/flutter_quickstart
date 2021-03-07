import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../app/bloc/application_bloc.dart';
import '../../core/index.dart';
import '../repo/login_repo.dart';

part 'login_screen_events.dart';
part 'login_screen_states.dart';

class LoginScreenBloc extends Bloc<LoginScreenEvent, LoginScreenState> {
  final _logger = getLogger();

  ApplicationBloc _applicationBloc;
  AnalyticsService _analyticsService;
  LoginRepo _loginRepo;

  LoginScreenBloc({
    @required ApplicationBloc applicationBloc,
    @required AnalyticsService analyticsService,
    @required LoginRepo loginRepo,
  })  : _applicationBloc = applicationBloc,
        _loginRepo = loginRepo,
        _analyticsService = analyticsService,
        super(LoginScreenStateInitial());

  @override
  Stream<LoginScreenState> mapEventToState(LoginScreenEvent event) async* {
    yield LoginScreenStateLoading();
    if (event is LoginScreenEventLoginPressed) {
      yield* _mapLoginScreenEventLoginPressedToState(event);
    } else if (event is LoginScreenEventOAuthLoginPressed) {
      yield* _mapLoginScreenEventOAuthLoginPressedToState(event);
    } else {
      yield* _mapUnhandledEventToState();
    }
  }

  Stream<LoginScreenState> _mapLoginScreenEventLoginPressedToState(
      LoginScreenEventLoginPressed event) async* {
    try {
      var token = await _loginRepo.doLogin(
          username: event.username, password: event.password);
      if (token != null) {
        _analyticsService.setUserDetails(
          // .add(AnalyticsEventSetUserDetails(
          username: event.username,
          email: event.username,
          userId: event.username,
        );
        _analyticsService.logLogin(
            method: 'usernamePassword', status: 'success');
        // .add(AnalyticsEventLogin('usernamePassword', 'success'));
        _applicationBloc.add(ApplicationEventUserLoggedIn(event.username));
        yield LoginScreenStateSuccess();
      } else {
        yield LoginScreenStateError();
      }
    } on RepositoryException catch (e) {
      _logger.w('repository failed', e);
      yield LoginScreenStateError();
    } catch (e) {
      _logger.e('Unknown error', e);
      yield LoginScreenStateError();
    }
  }

  Stream<LoginScreenState> _mapLoginScreenEventOAuthLoginPressedToState(
      LoginScreenEventOAuthLoginPressed state) async* {
    try {
      var token = await _loginRepo.initiateOAuth();
      if (token != null) {
        yield LoginScreenStateSuccess();

        _logger.i('authorizationAdditionalParameters');
        token.authorizationAdditionalParameters.forEach((key, val) {
          _logger.d('$key: $val');
        });

        _logger.i('tokenAdditionalParameters');
        token.tokenAdditionalParameters.forEach((key, val) {
          _logger.d('$key: $val');
        });

        // _analyticsService.add(AnalyticsEventSetUserDetails(
        //   username: event.username,
        //   email: event.username,
        //   userId: event.username,
        // ));
        _analyticsService.logLogin(method: 'oauth', status: 'success');
        // .add(AnalyticsEventLogin('oauth', 'success'));
        _applicationBloc.add(ApplicationEventUserLoggedIn(token.accessToken));
      } else {
        yield LoginScreenStateError();
      }
    } on RepositoryException catch (e) {
      _logger.w('repository failed', e);
      yield LoginScreenStateError();
    } catch (e) {
      _logger.e('Unknown error', e);
      yield LoginScreenStateError();
    }
  }

  Stream<LoginScreenState> _mapUnhandledEventToState() async* {
    yield LoginScreenStateError();
  }
}
