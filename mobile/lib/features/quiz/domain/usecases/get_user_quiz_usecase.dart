import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/core.dart';

import '../../../features.dart';

class GetUserQuizUsecase extends UseCase<List<Quiz>, GetUserQuizParams> {
  final QuizRepository repository;

  GetUserQuizUsecase(this.repository);

  @override
  Future<Either<Failure, List<Quiz>>> call(GetUserQuizParams params) async {
    return await repository.getQuizByCourseId(params.courseId);
  }
}

class GetUserQuizParams extends Equatable {
  const GetUserQuizParams({required this.courseId});

  final String courseId;

  @override
  List<Object> get props => [courseId];
}
