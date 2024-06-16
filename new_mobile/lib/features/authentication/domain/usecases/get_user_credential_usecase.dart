import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class GetUserCredentialUsecase extends UseCase<UserCredential, NoParams> {
  final AuthenticationRepository repository;

  GetUserCredentialUsecase({required this.repository});

  @override
  Future<Either<Failure, UserCredential>> call(NoParams params) async {
    return await repository.getUserCredential();
  }
}
