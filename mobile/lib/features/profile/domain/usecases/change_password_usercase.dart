import 'package:dartz/dartz.dart';

import 'package:equatable/equatable.dart';
import 'package:skill_bridge_mobile/features/profile/domain/repositories/profile_repository.dart.dart';
import '../../../../core/core.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

class ChangePasswordusecase extends UseCase<ChangePasswordEntity, Params> {
  final ProfileRepositories profileRepositories;

  ChangePasswordusecase({required this.profileRepositories});

  @override
  Future<Either<Failure, ChangePasswordEntity>> call(Params params) async {
    return await profileRepositories.postChangePassword(params.oldPassword, params.newPassword, params.repeatPassword);  
  }
}

class Params extends Equatable {
  final String oldPassword;
  final String newPassword;
  final String repeatPassword;

  Params({required this.oldPassword, required this.newPassword, required this.repeatPassword});

  @override
  List<Object> get props => [oldPassword, newPassword, repeatPassword];
}