part of 'application_bloc.dart';

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
