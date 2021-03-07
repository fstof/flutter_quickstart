part of 'application_bloc.dart';

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
