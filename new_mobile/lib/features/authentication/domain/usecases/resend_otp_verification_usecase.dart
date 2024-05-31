import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../repositories/authentication_repository.dart';

import '../../../../core/core.dart';

class ResendOtpVerificationUsecase
    extends UseCase<void, ResendOtpVerificationParams> {
  final AuthenticationRepository repository;

  ResendOtpVerificationUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(ResendOtpVerificationParams params) async {
    return await repository.resendOtpVerification(emailOrPhoneNumber: params.emailOrPhoneNumber);
  }
}

class ResendOtpVerificationParams extends Equatable {
  final String emailOrPhoneNumber;

  const ResendOtpVerificationParams({
    required this.emailOrPhoneNumber,
  });

  @override
  List<Object?> get props => [emailOrPhoneNumber];
}
