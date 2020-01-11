import 'package:equatable/equatable.dart';

class LoginScreenState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginScreenStateInitial extends LoginScreenState {}

class LoginScreenStateLoading extends LoginScreenState {}

class LoginScreenStateSuccess extends LoginScreenState {}

class LoginScreenStateError extends LoginScreenState {}
