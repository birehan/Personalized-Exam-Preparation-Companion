import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class GetQuestionByIdUsecase extends UseCase<Question, GetQuestionByIdParams> {
  final QuestionRepository repository;

  GetQuestionByIdUsecase({required this.repository});

  @override
  Future<Either<Failure, Question>> call(GetQuestionByIdParams params) async {
    return await repository.getQuestionById(questionId: params.questionId);
  }
}

class GetQuestionByIdParams extends Equatable {
  final String questionId;

  const GetQuestionByIdParams({
    required this.questionId,
  });

  @override
  List<Object?> get props => [questionId];
}
