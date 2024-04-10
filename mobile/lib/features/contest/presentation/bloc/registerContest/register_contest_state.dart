part of 'register_contest_bloc.dart';

class RegisterContestState extends Equatable {
  const RegisterContestState();

  @override
  List<Object> get props => [];
}

class RegisterContestInitial extends RegisterContestState {}

class RegisterContestSuccessfulState extends RegisterContestState {}

class RegisterContestFailedState extends RegisterContestState {}

class RegisterContestInprogressState extends RegisterContestState {}
