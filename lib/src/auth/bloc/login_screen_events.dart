part of 'login_screen_bloc.dart';

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

class LoginScreenEventOAuthLoginPressed extends LoginScreenEvent {}
