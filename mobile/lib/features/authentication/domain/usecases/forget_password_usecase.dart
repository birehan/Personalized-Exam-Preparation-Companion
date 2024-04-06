import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../repositories/authentication_repository.dart';

import '../../../../core/core.dart';

class ForgetPasswordUsecase extends UseCase<void, ForgetPasswordParams> {
  final AuthenticationRepository repository;

  ForgetPasswordUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(ForgetPasswordParams params) async {
    return await repository.forgetPassword(
      emailOrPhoneNumber: params.emailOrPhoneNumber,
      otp: params.otp,
    );
  }
}

class ForgetPasswordParams extends Equatable {
  final String emailOrPhoneNumber;
  final String otp;

  const ForgetPasswordParams({
    required this.emailOrPhoneNumber,
    required this.otp,
  });

  @override
  List<Object?> get props => [emailOrPhoneNumber, otp];
}
