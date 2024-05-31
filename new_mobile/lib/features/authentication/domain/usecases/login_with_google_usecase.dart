import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class SignInWithGoogleUsecase extends UseCase<UserCredential, NoParams> {
  final AuthenticationRepository repository;

  SignInWithGoogleUsecase({
    required this.repository,
  });

  @override
  Future<Either<Failure, UserCredential>> call(params) async {
    return await repository.signInWithGoogle();
  }
}
