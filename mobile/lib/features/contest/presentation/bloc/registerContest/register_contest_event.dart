part of 'register_contest_bloc.dart';

class RegisterContestEvent extends Equatable {
  const RegisterContestEvent();

  @override
  List<Object> get props => [];
}

class RegisterUserToContestEvent extends RegisterContestEvent {
  final String contestId;

  const RegisterUserToContestEvent({required this.contestId});
}
