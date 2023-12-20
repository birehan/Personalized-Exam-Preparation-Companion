import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../repositories/authentication_repository.dart';

class LogoutUsecase extends UseCase<void, NoParams> {
  final AuthenticationRepository repository;

  LogoutUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.logout();
  }
}
