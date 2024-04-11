import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/core.dart';
import '../repositories/authentication_repository.dart';

class SendOtpVerificationUsecase
    extends UseCase<void, SendOtpVerificationParams> {
  final AuthenticationRepository repository;

  SendOtpVerificationUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(SendOtpVerificationParams params) async {
    return await repository.sendOtpVerification(
        emailOrPhoneNumber: params.emailOrPhoneNumber);
  }
}

class SendOtpVerificationParams extends Equatable {
  final String emailOrPhoneNumber;

  const SendOtpVerificationParams({
    required this.emailOrPhoneNumber,
  });

  @override
  List<Object?> get props => [emailOrPhoneNumber];
}
