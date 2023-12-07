import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/core.dart';
import '../../../../features.dart';

part 'quiz_create_event.dart';
part 'quiz_create_state.dart';

class QuizCreateBloc extends Bloc<QuizCreateEvent, QuizCreateState> {
  final CreateQuizUsecase createQuizUsecase;

  QuizCreateBloc({
    required this.createQuizUsecase,
  }) : super(QuizCreateInitial()) {
    on<CreateQuizEvent>(_onCreateQuiz);
  }

  void _onCreateQuiz(
      CreateQuizEvent event, Emitter<QuizCreateState> emit) async {
    emit(const CreateQuizState(status: QuizCreateStatus.loading));
    final failureOrQuizId = await createQuizUsecase(
      CreateQuizParams(
        name: event.name,
        chapters: event.chapters,
        numberOfQuestion: event.numberOfQuestions,
        courseId: event.courseId,
      ),
    );
    emit(_quizIdOrFailure(failureOrQuizId));
  }

  QuizCreateState _quizIdOrFailure(Either<Failure, String> failureOrQuizId) {
    return failureOrQuizId.fold(
      (error) => CreateQuizState(
        status: QuizCreateStatus.error,
        errorMessage: error.errorMessage,
      ),
      (quizId) => CreateQuizState(
        status: QuizCreateStatus.loaded,
        quizId: quizId,
      ),
    );
  }
}
