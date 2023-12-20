import 'package:equatable/equatable.dart';

import '../core.dart';

abstract class Failure extends Equatable {
  abstract final String errorMessage;
  @override
  List<Object?> get props => [];
}

class ServerFailure extends Failure {
  @override
  final String errorMessage;
  ServerFailure({this.errorMessage = 'Server failure'});
}

class CacheFailure extends Failure {
  @override
  final String errorMessage;
  CacheFailure({this.errorMessage = 'Cache failure'});
}

class NetworkFailure extends Failure {
  @override
  final String errorMessage;
  NetworkFailure({this.errorMessage = 'No internet connection'});
}

class UnauthorizedRequestFailure extends Failure {
  @override
  final String errorMessage;

  UnauthorizedRequestFailure({this.errorMessage = 'User not authenticated'});
}

class AnonymousFailure extends Failure {
  @override
  final String errorMessage;
  AnonymousFailure({this.errorMessage = 'Unknown error happened'});
}

class SignInWithGoogleFailure extends Failure {
  @override
  final String errorMessage;

  SignInWithGoogleFailure({
    this.errorMessage = 'Sign In With Google Failed',
  });
}

SignInWithGoogleFailure handleSignInException(
    SignInWithGoogleException exception) {
  return SignInWithGoogleFailure(errorMessage: exception.errorMessage);
}

class SignOutWithGoogleFailure extends Failure {
  @override
  final String errorMessage;

  SignOutWithGoogleFailure({
    this.errorMessage = 'Sign Out With Google Failed',
  });
}

SignOutWithGoogleFailure handleSignOutException(
    SignOutWithGoogleException exception) {
  return SignOutWithGoogleFailure(errorMessage: exception.errorMessage);
}

class CreateQuizFailure extends Failure {
  @override
  final String errorMessage;

  CreateQuizFailure({required this.errorMessage});
}

class AuthenticationFailure extends Failure {
  @override
  final String errorMessage;

  AuthenticationFailure({
    required this.errorMessage,
  });
}
