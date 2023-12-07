// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object?> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

enum AuthStatus { loading, loaded, error }

class SignupState extends AuthenticationState {
  final AuthStatus status;
  final String? errorMessage;

  const SignupState({
    required this.status,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [status, errorMessage];
}

class LoggedInState extends AuthenticationState {
  final AuthStatus status;
  final String? errorMessage;
  final UserCredential? userCredential;

  const LoggedInState({
    required this.status,
    this.errorMessage,
    this.userCredential,
  });

  @override
  List<Object?> get props => [status, userCredential, errorMessage];
}

class ForgetPasswordState extends AuthenticationState {
  final AuthStatus status;
  final String? errorMessage;

  const ForgetPasswordState({
    required this.status,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [status, errorMessage];
}

class ChangePasswordState extends AuthenticationState {
  final AuthStatus status;
  final String? errorMessage;

  const ChangePasswordState({required this.status, this.errorMessage,});

  @override
  List<Object?> get props => [status, errorMessage];
}

class SendOtpVerificationState extends AuthenticationState {
  final AuthStatus status;
  final String? errorMessage;

  const SendOtpVerificationState({
    required this.status,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [status, errorMessage];
}

class ResendOtpVerificationState extends AuthenticationState {
  final AuthStatus status;
  final String? errorMessage;

  const ResendOtpVerificationState({
    required this.status,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [status, errorMessage];
}

class InitializeAppState extends AuthenticationState {
  final AuthStatus status;

  const InitializeAppState({required this.status});

  @override
  List<Object> get props => [status];
}

class GetAppInitializationState extends AuthenticationState {
  final AuthStatus status;

  const GetAppInitializationState({required this.status});

  @override
  List<Object> get props => [status];
}

class SignInWithGoogleState extends AuthenticationState {
  final AuthStatus status;
  final String? errorMessage;
  final User? user;

  const SignInWithGoogleState({
    required this.status,
    this.errorMessage,
    this.user,
  });

  @override
  List<Object> get props => [status];
}

class SignOutWithGoogleState extends AuthenticationState {
  final AuthStatus status;
  final String? errorMessage;

  const SignOutWithGoogleState({
    required this.status,
    this.errorMessage,
  });

  @override
  List<Object> get props => [status];
}

class AuthenticatedWithGoogleState extends AuthenticationState {
  final AuthStatus status;
  final String? errorMessage;
  final bool? isAuthenticated;

  const AuthenticatedWithGoogleState({
    required this.status,
    this.errorMessage,
    this.isAuthenticated,
  });

  @override
  List<Object> get props => [status];
}
