import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class UpsertOfflineMockUserAnswerUsecase
    extends UseCase<void, UpsertOfflineMockUserAnswerParams> {
  UpsertOfflineMockUserAnswerUsecase({
    required this.repository,
  });

  final MockExamRepository repository;

  @override
  Future<Either<Failure, void>> call(params) async {
    return await repository.upsertOfflineMockUserAnswer(
      params.mockId,
      params.userAnswers,
    );
  }
}

class UpsertOfflineMockUserAnswerParams extends Equatable {
  final String mockId;
  final List<QuestionUserAnswer> userAnswers;

  const UpsertOfflineMockUserAnswerParams({
    required this.mockId,
    required this.userAnswers,
  });

  @override
  List<Object?> get props => [
        mockId,
        userAnswers,
      ];
}
