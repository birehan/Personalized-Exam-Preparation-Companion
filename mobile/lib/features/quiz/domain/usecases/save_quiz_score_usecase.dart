import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class SaveQuizScoreUsecase extends UseCase<void, SaveQuizScoreParams> {
  final QuizRepository repository;

  SaveQuizScoreUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(params) async {
    return await repository.saveQuizScore(
      quizId: params.quizId,
      score: params.score,
    );
  }
}

class SaveQuizScoreParams extends Equatable {
  final String quizId;
  final int score;

  const SaveQuizScoreParams({
    required this.quizId,
    required this.score,
  });

  @override
  List<Object?> get props => [
        quizId,
        score,
      ];
}
