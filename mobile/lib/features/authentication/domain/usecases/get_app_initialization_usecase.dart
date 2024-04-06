import 'package:dartz/dartz.dart';
import '../repositories/authentication_repository.dart';

import '../../../../core/core.dart';

class GetAppInitializationUsecase extends UseCase<bool, NoParams> {
  final AuthenticationRepository repository;

  GetAppInitializationUsecase({required this.repository});

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.getAppInitialization();
  }
}
