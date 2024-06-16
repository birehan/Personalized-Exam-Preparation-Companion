import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../features.dart';
import '../../../../core/core.dart';

class FetchDailyQuizForAnalysisUsecase extends UseCase<DailyQuiz, FetchDailyQuizForAnalysisParams> {
  FetchDailyQuizForAnalysisUsecase({
    required this.repository,
  });

  final HomeRepository repository;

  @override
  Future<Either<Failure, DailyQuiz>> call(FetchDailyQuizForAnalysisParams params) async {
    return await repository.fetchDailyQuizForAnalysis(params.id);
  }
}

class FetchDailyQuizForAnalysisParams extends Equatable {
  const FetchDailyQuizForAnalysisParams({
    required this.id,
  });

  final String id;

  @override
  List<Object?> get props => [id];
}
