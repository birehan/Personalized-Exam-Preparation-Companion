import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class GetQuizByIdUsecase extends UseCase<QuizQuestion, GetQuizByIdParams> {
  final QuizRepository repository;

  GetQuizByIdUsecase(this.repository);

  @override
  Future<Either<Failure, QuizQuestion>> call(params) async {
    return await repository.getQuizById(params.quizId);
  }
}

class GetQuizByIdParams extends Equatable {
  final String quizId;

  const GetQuizByIdParams({
    required this.quizId,
  });

  @override
  List<Object?> get props => [quizId];
}
