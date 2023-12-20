import 'package:dartz/dartz.dart';
import '../../../features.dart';

import '../../../../core/core.dart';

class GetSignInWithGoogleUsecase extends UseCase<bool, NoParams> {
  final AuthenticationRepository repository;

  GetSignInWithGoogleUsecase({
    required this.repository,
  });

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.isAuthenticatedWithGoogle();
  }
}
