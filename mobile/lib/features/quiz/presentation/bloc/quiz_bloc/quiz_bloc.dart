import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/core.dart';
import '../../../../features.dart';

part 'quiz_event.dart';
part 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final GetUserQuizUsecase getUserQuizUsecase;

  QuizBloc({
    required this.getUserQuizUsecase,
  }) : super(QuizInitial()) {
    on<GetUserQuizEvent>(_onGetUserQuiz);
  }

  void _onGetUserQuiz(GetUserQuizEvent event, Emitter<QuizState> emit) async {
    emit(const GetUserQuizState(status: QuizStatus.loading));
    final failureOrQuizzes = await getUserQuizUsecase(GetUserQuizParams(
      courseId: event.courseId,
      isRefreshed: event.isRefreshed,
    ));
    emit(_quizzesOrFailure(failureOrQuizzes));
  }

  QuizState _quizzesOrFailure(Either<Failure, List<Quiz>> failureOrQuizzes) {
    return failureOrQuizzes.fold(
      (l) => GetUserQuizState(
          status: QuizStatus.error, errorMessage: l.errorMessage),
      (quizzes) => GetUserQuizState(
        status: QuizStatus.loaded,
        quizzes: quizzes,
      ),
    );
  }
}
