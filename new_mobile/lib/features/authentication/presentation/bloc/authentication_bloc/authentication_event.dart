part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class SignupEvent extends AuthenticationEvent {
  final String emailOrPhoneNumber;
  final String firstName;
  final String lastName;
  final String password;
  final String otp;
  final BuildContext? context;

  const SignupEvent({
    required this.emailOrPhoneNumber,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.otp,
    this.context,
  });

  @override
  List<Object> get props =>
      [emailOrPhoneNumber, firstName, lastName, password, otp];
}

class LoginEvent extends AuthenticationEvent {
  final String emailOrPhoneNumber;
  final String password;
  final bool rememberMe;
  final BuildContext context;

  const LoginEvent({
    required this.emailOrPhoneNumber,
    required this.password,
    required this.rememberMe,
    required this.context,
  });

  @override
  List<Object> get props => [emailOrPhoneNumber, password, rememberMe];
}

class LogoutEvent extends AuthenticationEvent {}

class ForgetPasswordEvent extends AuthenticationEvent {
  final String emailOrPhoneNumber;
  final String otp;
  final BuildContext? context;

  const ForgetPasswordEvent(
      {required this.emailOrPhoneNumber, required this.otp, this.context});

  @override
  List<Object> get props => [emailOrPhoneNumber, otp];
}

class ChangePasswordEvent extends AuthenticationEvent {
  final String emailOrPhoneNumber;
  final String newPassword;
  final String confirmPassword;
  final String otp;
  final BuildContext context;

  const ChangePasswordEvent(
      {required this.emailOrPhoneNumber,
      required this.newPassword,
      required this.confirmPassword,
      required this.otp,
      required this.context});

  @override
  List<Object> get props =>
      [emailOrPhoneNumber, newPassword, confirmPassword, otp];
}

class SendOtpVerficationEvent extends AuthenticationEvent {
  final String emailOrPhoneNumber;
  final bool isForForgotPassword;

  const SendOtpVerficationEvent(
      {required this.emailOrPhoneNumber, required this.isForForgotPassword});
}

class ResendOtpVerificationEvent extends AuthenticationEvent {
  final String emailOrPhoneNumber;
  final BuildContext? context;

  const ResendOtpVerificationEvent(
      {required this.emailOrPhoneNumber, this.context});
}

class InitializeAppEvent extends AuthenticationEvent {}

class GetAppInitializationEvent extends AuthenticationEvent {}

class SignInWithGoogleEvent extends AuthenticationEvent {}

class SignOutWithGoogleEvent extends AuthenticationEvent {}

class AuthenticatedWithGoogleEvent extends AuthenticationEvent {}
