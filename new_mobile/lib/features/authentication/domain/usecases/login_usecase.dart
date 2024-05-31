import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../entities/user_credential.dart';
import '../repositories/authentication_repository.dart';

import '../../../../core/core.dart';

class LoginUsecase extends UseCase<UserCredential, LoginParams> {
  final AuthenticationRepository repository;

  LoginUsecase({
    required this.repository,
  });

  @override
  Future<Either<Failure, UserCredential>> call(LoginParams params) async {
    return await repository.login(
      emailOrPhoneNumber: params.emailOrPhoneNumber,
      password: params.password,
      rememberMe: params.rememberMe,
    );
  }
}

class LoginParams extends Equatable {
  final String emailOrPhoneNumber;
  final String password;
  final bool rememberMe;

  const LoginParams({
    required this.emailOrPhoneNumber,
    required this.password,
    required this.rememberMe,
  });

  @override
  List<Object?> get props => [emailOrPhoneNumber, password, rememberMe];
}
