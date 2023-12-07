import 'package:dartz/dartz.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:skill_bridge_mobile/features/profile/domain/repositories/profile_repository.dart.dart';
import '../../../../core/core.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';

class ChangeUsernameUsecase extends UseCase<ChangeUsernameEntity, Params> {
  final ProfileRepositories profileRepositories;

  ChangeUsernameUsecase({required this.profileRepositories});

  @override
  Future<Either<Failure, ChangeUsernameEntity>> call(Params params) async {
    return await profileRepositories.postChangeUsername(params.firstname, params.lastname);
  }
}

class Params extends Equatable {
  final String firstname;
  final String lastname;

  Params({required this.firstname, required this.lastname});

  @override
  List<Object> get props => [firstname, lastname];
}