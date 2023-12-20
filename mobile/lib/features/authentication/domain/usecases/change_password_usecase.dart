import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../repositories/authentication_repository.dart';

import '../../../../core/core.dart';

class ChangePasswordUsecase extends UseCase<void, ChangePasswordParams> {
  final AuthenticationRepository repository;

  ChangePasswordUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(ChangePasswordParams params) async {
    return await repository.changePassword(
      emailOrPhoneNumber: params.emailOrPhoneNumber,
      newPassword: params.newPassword,
      confirmPassword: params.confirmPassword,
      otp: params.otp,
    );
  }
}

class ChangePasswordParams extends Equatable {
  final String emailOrPhoneNumber;
  final String newPassword;
  final String confirmPassword;
  final String otp;

  const ChangePasswordParams({
    required this.emailOrPhoneNumber,
    required this.newPassword,
    required this.confirmPassword,
    required this.otp,
  });

  @override
  List<Object?> get props => [emailOrPhoneNumber, newPassword, confirmPassword, otp];
}
