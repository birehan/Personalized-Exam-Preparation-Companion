import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class CreateQuizUsecase extends UseCase<String, CreateQuizParams> {
  final QuizRepository repository;

  CreateQuizUsecase(this.repository);

  @override
  Future<Either<Failure, String>> call(CreateQuizParams params) async {
    return await repository.createQuiz(
      name: params.name,
      chapters: params.chapters,
      numberOfQuestion: params.numberOfQuestion,
      courseId: params.courseId,
    );
  }
}

class CreateQuizParams extends Equatable {
  final String name;
  final List<String> chapters;
  final int numberOfQuestion;
  final String courseId;

  const CreateQuizParams({
    required this.name,
    required this.chapters,
    required this.numberOfQuestion,
    required this.courseId,
  });

  @override
  List<Object?> get props => [
        name,
        chapters,
        numberOfQuestion,
        courseId,
      ];
}
