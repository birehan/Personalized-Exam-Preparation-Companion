import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:prepgenie/features/contest/domain/usecases/fetch_contest_questions_by_category_usecase.dart';

import '../../../contest.dart';

part 'fetch_contest_questions_by_category_event.dart';
part 'fetch_contest_questions_by_category_state.dart';

class FetchContestQuestionsByCategoryBloc extends Bloc<
    FetchContestQuestionsByCategoryEvent,
    FetchContestQuestionsByCategoryState> {
  FetchContestQuestionsByCategoryBloc({
    required this.fetchContestQuestionsByCategoryUsecase,
  }) : super(FetchContestQuestionsByCategoryInitial()) {
    on<FetchContestQuestionsByCategoryEvent>(
        _onFetchContestQuestionsByCategory);
  }

  final FetchContestQuestionsByCategoryUsecase
      fetchContestQuestionsByCategoryUsecase;

  void _onFetchContestQuestionsByCategory(
      FetchContestQuestionsByCategoryEvent event,
      Emitter<FetchContestQuestionsByCategoryState> emit) async {
    emit(FetchContestQuestionsByCategoryLoading());
    final failureOrContestQuestions =
        await fetchContestQuestionsByCategoryUsecase(
      FetchContestQuestionsByCategoryParams(categoryId: event.categoryId),
    );
    emit(
      failureOrContestQuestions.fold(
        (l) => FetchContestQuestionsByCategoryFailed(),
        (contestQuestions) => FetchContestQuestionsByCategoryLoaded(
          contestQuestions: contestQuestions,
        ),
      ),
    );
  }
}
