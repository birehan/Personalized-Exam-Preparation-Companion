import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class DeleteDeviceTokenUsecase extends UseCase<void, NoParams> {
  DeleteDeviceTokenUsecase({
    required this.repository,
  });

  final AuthenticationRepository repository;

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.deleteDeviceToken();
  }
}

