import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/core.dart';

import '../../../features.dart';

class GetUserQuizUsecase extends UseCase<List<Quiz>, GetUserQuizParams> {
  final QuizRepository repository;

  GetUserQuizUsecase(this.repository);

  @override
  Future<Either<Failure, List<Quiz>>> call(GetUserQuizParams params) async {
    return await repository.getQuizByCourseId(
      courseId: params.courseId,
      isRefreshed: params.isRefreshed,
    );
  }
}

class GetUserQuizParams extends Equatable {
  const GetUserQuizParams({
    required this.courseId,
    required this.isRefreshed,
  });

  final String courseId;
  final bool isRefreshed;

  @override
  List<Object> get props => [courseId, isRefreshed];
}
