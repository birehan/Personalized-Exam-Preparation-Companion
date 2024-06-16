import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class StoreDeviceTokenUsecase extends UseCase<void, NoParams> {
  StoreDeviceTokenUsecase({
    required this.repository,
  });

  final AuthenticationRepository repository;

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.storeDeviceToken();
  }
}

// class StoreDeviceTokenParams extends Equatable {
//   const StoreDeviceTokenParams({
//     required this.userId,
//     required this.deviceToken,
//   });

//   final String userId;
//   final String deviceToken;

//   @override
//   List<Object?> get props => [userId, deviceToken];
// }
