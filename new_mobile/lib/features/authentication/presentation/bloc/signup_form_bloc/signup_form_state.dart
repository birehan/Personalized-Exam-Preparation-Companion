part of 'signup_form_bloc.dart';

abstract class SignupFormState extends Equatable {
  const SignupFormState();

  @override
  List<Object> get props => [];
}

class SignupFormInitial extends SignupFormState {}

class SignupForm extends SignupFormState {
  final String emailOrPhoneNumber;
  final String firstName;
  final String lastName;
  final String password;
  final String otp;
  final String department;
  final String major;

  const SignupForm({
    required this.emailOrPhoneNumber,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.otp,
    required this.department,
    required this.major,
  });

  SignupForm copyWith({
    String? email,
    String? firstName,
    String? lastName,
    String? password,
    String? otp,
    String? department,
    String? major,
  }) {
    return SignupForm(
      emailOrPhoneNumber: email ?? this.emailOrPhoneNumber,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      password: password ?? this.password,
      otp: otp ?? this.otp,
      department: department ?? this.department,
      major: major ?? this.major,
    );
  }

  @override
  List<Object> get props => [
        emailOrPhoneNumber,
        firstName,
        lastName,
        password,
        otp,
        department,
        major,
      ];
}
