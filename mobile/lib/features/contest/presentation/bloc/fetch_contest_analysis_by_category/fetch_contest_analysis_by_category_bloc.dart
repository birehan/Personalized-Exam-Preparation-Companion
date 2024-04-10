import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../features.dart';

part 'fetch_contest_analysis_by_category_event.dart';
part 'fetch_contest_analysis_by_category_state.dart';

class FetchContestAnalysisByCategoryBloc extends Bloc<
    FetchContestAnalysisByCategoryEvent, FetchContestAnalysisByCategoryState> {
  FetchContestAnalysisByCategoryBloc({
    required this.fetchContestAnalysisByCategoryUsecase,
  }) : super(FetchContestAnalysisByCategoryInitial()) {
    on<FetchContestAnalysisByCategoryEvent>(_onFetchContestAnalysisByCategory);
  }

  final FetchContestAnalysisByCategoryUsecase
      fetchContestAnalysisByCategoryUsecase;

  void _onFetchContestAnalysisByCategory(
    FetchContestAnalysisByCategoryEvent event,
    Emitter<FetchContestAnalysisByCategoryState> emit,
  ) async {
    emit(FetchContestAnalysisByCategoryLoading());
    final failureOrContestQuestions =
        await fetchContestAnalysisByCategoryUsecase(
            FetchContestAnalysisByCategoryParams(categoryId: event.categoryId));
    emit(
      failureOrContestQuestions.fold(
        (l) =>
            FetchContestAnalysisByCategoryFailed(errorMessage: l.errorMessage),
        (contestQuestions) => FetchContestAnalysisByCategoryLoaded(
            contestQuestions: contestQuestions),
      ),
    );
  }
}
