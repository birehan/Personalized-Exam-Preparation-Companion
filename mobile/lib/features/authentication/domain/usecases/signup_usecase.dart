import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/core.dart';
import '../entities/user_credential.dart';
import '../repositories/authentication_repository.dart';

class SignupUsecase extends UseCase<UserCredential, SignupParams> {
  final AuthenticationRepository repository;

  SignupUsecase({required this.repository});

  @override
  Future<Either<Failure, UserCredential>> call(SignupParams params) async {
    return await repository.signup(
      emailOrPhoneNumber: params.emailOrPhoneNumber,
      password: params.password,
      firstName: params.firstName,
      lastName: params.lastName,
      otp: params.otp,
    );
  }
}

class SignupParams extends Equatable {
  // final UserCredential userCredential;
  final String emailOrPhoneNumber;
  final String password;
  final String firstName;
  final String lastName;
  final String otp;

  const SignupParams({
    required this.emailOrPhoneNumber,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.otp,
  });

  @override
  List<Object?> get props =>
      [emailOrPhoneNumber, password, firstName, lastName, otp];
}
