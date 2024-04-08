import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class SubmitDailyQuizAnswerUsecase
    extends UseCase<void, SubmitDailyQuizAnswerParams> {
  SubmitDailyQuizAnswerUsecase({
    required this.repository,
  });

  final HomeRepository repository;

  @override
  Future<Either<Failure, void>> call(SubmitDailyQuizAnswerParams params) async {
    return await repository.submitDailyQuizAnswer(params.dailyQuizAnswer);
  }
}

class SubmitDailyQuizAnswerParams extends Equatable {
  const SubmitDailyQuizAnswerParams({
    required this.dailyQuizAnswer,
  });

  final DailyQuizAnswer dailyQuizAnswer;

  @override
  List<Object?> get props => [dailyQuizAnswer];
}
