import 'package:dartz/dartz.dart';
import '../../../../core/core.dart';

import '../../../features.dart';

class SignOutWithGoogleUsecase extends UseCase<void, NoParams> {
  final AuthenticationRepository repository;

  SignOutWithGoogleUsecase({
    required this.repository,
  });

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.logoutWithGoogle();
  }
}
