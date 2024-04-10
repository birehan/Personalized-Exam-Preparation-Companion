import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class GetQuizByIdUsecase extends UseCase<QuizQuestion, GetQuizByIdParams> {
  final QuizRepository repository;

  GetQuizByIdUsecase(this.repository);

  @override
  Future<Either<Failure, QuizQuestion>> call(params) async {
    return await repository.getQuizById(
      quizId: params.quizId,
      isRefreshed: params.isRefreshed,
    );
  }
}

class GetQuizByIdParams extends Equatable {
  final String quizId;
  final bool isRefreshed;

  const GetQuizByIdParams({
    required this.quizId,
    required this.isRefreshed,
  });

  @override
  List<Object?> get props => [quizId, isRefreshed];
}
