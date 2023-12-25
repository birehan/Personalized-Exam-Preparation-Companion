part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class SignupEvent extends AuthenticationEvent {
  // final UserCredential userCredential;
  final String emailOrPhoneNumber;
  final String firstName;
  final String lastName;
  final String password;
  final String otp;

  const SignupEvent({
    required this.emailOrPhoneNumber,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.otp,
  });

  @override
  List<Object> get props =>
      [emailOrPhoneNumber, firstName, lastName, password, otp];
}

class LoginEvent extends AuthenticationEvent {
  final String emailOrPhoneNumber;
  final String password;
  final bool rememberMe;

  const LoginEvent({
    required this.emailOrPhoneNumber,
    required this.password,
    required this.rememberMe,
  });

  @override
  List<Object> get props => [emailOrPhoneNumber, password, rememberMe];
}

class LogoutEvent extends AuthenticationEvent {}

class ForgetPasswordEvent extends AuthenticationEvent {
  final String emailOrPhoneNumber;
  final String otp;

  const ForgetPasswordEvent({
    required this.emailOrPhoneNumber,
    required this.otp,
  });

  @override
  List<Object> get props => [emailOrPhoneNumber, otp];
}

class ChangePasswordEvent extends AuthenticationEvent {
  final String emailOrPhoneNumber;
  final String newPassword;
  final String confirmPassword;
  final String otp;

  const ChangePasswordEvent({
    required this.emailOrPhoneNumber,
    required this.newPassword,
    required this.confirmPassword,
    required this.otp,
  });

  @override
  List<Object> get props => [emailOrPhoneNumber, newPassword, confirmPassword, otp];
}

class SendOtpVerficationEvent extends AuthenticationEvent {
  final String emailOrPhoneNumber;

  const SendOtpVerficationEvent({required this.emailOrPhoneNumber});
}

class ResendOtpVerificationEvent extends AuthenticationEvent {
  final String emailOrPhoneNumber;

  const ResendOtpVerificationEvent({required this.emailOrPhoneNumber});
}

class InitializeAppEvent extends AuthenticationEvent {}

class GetAppInitializationEvent extends AuthenticationEvent {}

class SignInWithGoogleEvent extends AuthenticationEvent {}

class SignOutWithGoogleEvent extends AuthenticationEvent {}

class AuthenticatedWithGoogleEvent extends AuthenticationEvent {}
