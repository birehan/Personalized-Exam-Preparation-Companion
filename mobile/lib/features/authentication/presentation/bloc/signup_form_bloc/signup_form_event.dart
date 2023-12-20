part of 'signup_form_bloc.dart';

abstract class SignupFormEvent extends Equatable {
  const SignupFormEvent();

  @override
  List<Object> get props => [];
}

class ChangeEmailEvent extends SignupFormEvent {
  final String email;

  const ChangeEmailEvent({
    required this.email,
  });

  @override
  List<Object> get props => [email];
}

class ChangeFirstNameEvent extends SignupFormEvent {
  final String firstName;

  const ChangeFirstNameEvent({
    required this.firstName,
  });

  @override
  List<Object> get props => [firstName];
}

class ChangeLastNameEvent extends SignupFormEvent {
  final String lastName;

  const ChangeLastNameEvent({
    required this.lastName,
  });

  @override
  List<Object> get props => [lastName];
}

class ChangePassEvent extends SignupFormEvent {
  final String password;

  const ChangePassEvent({
    required this.password,
  });

  @override
  List<Object> get props => [password];
}

class ChangeOTPEvent extends SignupFormEvent {
  final String otp;

  const ChangeOTPEvent({required this.otp});

  @override
  List<Object> get props => [otp];
}

class ChangeDepartmentEvent extends SignupFormEvent {
  final String department;

  const ChangeDepartmentEvent({required this.department});

  @override
  List<Object> get props => [department];
}

class ChangeMajorEvent extends SignupFormEvent {
  final String major;

  const ChangeMajorEvent({required this.major});

  @override
  List<Object> get props => [major];
}
