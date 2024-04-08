import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class GetEndOfChapterQuestionsUsecase
    extends UseCase<List<EndQuestionsAndAnswer>, GetEndChapterQuestionsParams> {
  final QuestionRepository repository;

  GetEndOfChapterQuestionsUsecase({required this.repository});

  @override
  Future<Either<Failure, List<EndQuestionsAndAnswer>>> call(
      GetEndChapterQuestionsParams params) async {
    return await repository.getEndOfChapterQuestions(params.chapterId);
  }
}

class GetEndChapterQuestionsParams extends Equatable {
  final String chapterId;

  const GetEndChapterQuestionsParams({
    required this.chapterId,
  });

  @override
  List<Object?> get props => [chapterId];
}
