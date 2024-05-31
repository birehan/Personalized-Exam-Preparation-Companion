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
        emailOrPhoneNumber: params.emailOrPhoneNumber,
        isForForgotPassword: params.isForForgotPassword);
  }
}

class SendOtpVerificationParams extends Equatable {
  final String emailOrPhoneNumber;
  final bool isForForgotPassword;

  const SendOtpVerificationParams(
      {required this.emailOrPhoneNumber, required this.isForForgotPassword});

  @override
  List<Object?> get props => [emailOrPhoneNumber];
}
