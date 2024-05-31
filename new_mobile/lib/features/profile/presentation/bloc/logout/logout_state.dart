part of 'logout_bloc.dart';

abstract class LogoutState extends Equatable {
  const LogoutState();

  @override
  List<Object> get props => [];
}

class LogoutInitial extends LogoutState {}

class LogedOutState extends LogoutState {}

class LogOutFailedState extends LogoutState {
  final String errorMessage;
  final Failure failure;

  const LogOutFailedState({required this.errorMessage, required this.failure});
}

class LoagingOutState extends LogoutState {}
