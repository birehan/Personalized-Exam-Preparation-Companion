import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class GetEndSubtopicQuestionUsecase
    extends UseCase<List<EndQuestionsAndAnswer>, GetEndSubtopicQuestionParams> {
  final QuestionRepository repository;

  GetEndSubtopicQuestionUsecase(this.repository);

  @override
  Future<Either<Failure, List<EndQuestionsAndAnswer>>> call(
      GetEndSubtopicQuestionParams params) async {
    return await repository.getEndofSubtopicQuestions(params.subtopicId);
  }
}

class GetEndSubtopicQuestionParams extends Equatable {
  final String subtopicId;

  const GetEndSubtopicQuestionParams({
    required this.subtopicId,
  });

  @override
  List<Object?> get props => [subtopicId];
}
