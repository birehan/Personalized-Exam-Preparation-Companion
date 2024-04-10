import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class FetchDailyQuestUsecase extends UseCase<List<DailyQuest>, NoParams> {
  FetchDailyQuestUsecase({
    required this.repository,
  });

  final HomeRepository repository;

  @override
  Future<Either<Failure, List<DailyQuest>>> call(NoParams params) async {
    return await repository.fetchDailyQuest();
  }
}
