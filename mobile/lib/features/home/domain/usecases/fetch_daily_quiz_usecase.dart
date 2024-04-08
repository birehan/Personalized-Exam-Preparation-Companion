import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class FetchDailyQuizUsecase extends UseCase<DailyQuiz, NoParams> {
  FetchDailyQuizUsecase({
    required this.repository,
  });

  final HomeRepository repository;

  @override
  Future<Either<Failure, DailyQuiz>> call(NoParams params) async {
    return await repository.fetchDailyQuiz();
  }
}
