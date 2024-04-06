import 'package:dartz/dartz.dart';
import '../repositories/authentication_repository.dart';

import '../../../../core/core.dart';

class InitializeAppUsecase extends UseCase<void, NoParams> {
  final AuthenticationRepository repository;

  InitializeAppUsecase({
    required this.repository,
  });

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.initializeApp();
  }
}
