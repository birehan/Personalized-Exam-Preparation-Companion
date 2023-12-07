import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class SignInWithGoogleUsecase extends UseCase<User?, NoParams> {
  final AuthenticationRepository repository;

  SignInWithGoogleUsecase({
    required this.repository,
  });

  @override
  Future<Either<Failure, User?>> call(params) async {
    return await repository.signInWithGoogle();
  }
}
