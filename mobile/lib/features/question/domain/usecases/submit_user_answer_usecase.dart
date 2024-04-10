import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class SubmitUserAnswerUsecase extends UseCase<void, SubmitUserAnswerParams> {
  final QuestionRepository repository;

  SubmitUserAnswerUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(SubmitUserAnswerParams params) async {
    return await repository.submitUserAnswer(params.questionUserAnswers);
  }
}

class SubmitUserAnswerParams extends Equatable {
  final List<QuestionUserAnswer> questionUserAnswers;

  const SubmitUserAnswerParams({
    required this.questionUserAnswers,
  });

  @override
  List<Object?> get props => [questionUserAnswers];
}
