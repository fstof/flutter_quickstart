import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_quick_start/src/auth/repo/login_repo.dart';
import 'package:flutter_quick_start/src/core/analytics/bloc/analytics_bloc.dart';
import 'package:flutter_quick_start/src/core/core.dart';
import 'package:flutter_quick_start/src/core/exception/exceptions.dart';

class LoginScreenBloc extends Bloc<LoginScreenEvent, LoginScreenState> {
  final _logger = getLogger();

  ApplicationBloc _applicationBloc;
  AnalyticsBloc _analyticsBloc;
  LoginRepo _loginRepo;

  LoginScreenBloc({
    @required ApplicationBloc applicationBloc,
    @required AnalyticsBloc analyticsBloc,
    @required LoginRepo loginRepo,
  })  : _applicationBloc = applicationBloc,
        _loginRepo = loginRepo,
        _analyticsBloc = analyticsBloc,
        super();

  @override
  LoginScreenState get initialState => LoginScreenStateInitial();

  @override
  Stream<LoginScreenState> mapEventToState(LoginScreenEvent event) async* {
    yield LoginScreenStateLoading();
    if (event is LoginScreenEventLoginPressed) {
      yield* _mapLoginScreenEventLoginPressedToState(event);
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
        _analyticsBloc.add(AnalyticsEventSetUserDetails(
          username: event.username,
          email: event.username,
          userId: event.username,
        ));
        _analyticsBloc.add(
          AnalyticsEventLogin('usernamePassword', 'success'),
        );
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

  Stream<LoginScreenState> _mapUnhandledEventToState() async* {
    yield LoginScreenStateError();
  }
}

class LoginScreenEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginScreenEventLoginPressed extends LoginScreenEvent {
  final String username, password;
  LoginScreenEventLoginPressed(this.username, this.password);
  @override
  List<Object> get props => [username, password];
}

class LoginScreenState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginScreenStateInitial extends LoginScreenState {}

class LoginScreenStateLoading extends LoginScreenState {}

class LoginScreenStateSuccess extends LoginScreenState {}

class LoginScreenStateError extends LoginScreenState {}
