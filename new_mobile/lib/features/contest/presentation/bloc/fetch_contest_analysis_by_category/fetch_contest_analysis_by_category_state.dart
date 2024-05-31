part of 'fetch_contest_analysis_by_category_bloc.dart';

class FetchContestAnalysisByCategoryState extends Equatable {
  const FetchContestAnalysisByCategoryState();

  @override
  List<Object> get props => [];
}

class FetchContestAnalysisByCategoryInitial
    extends FetchContestAnalysisByCategoryState {}

class FetchContestAnalysisByCategoryLoading
    extends FetchContestAnalysisByCategoryState {}

class FetchContestAnalysisByCategoryLoaded
    extends FetchContestAnalysisByCategoryState {
  const FetchContestAnalysisByCategoryLoaded({
    required this.contestQuestions,
  });

  final List<ContestQuestion> contestQuestions;

  @override
  List<Object> get props => [contestQuestions];
}

class FetchContestAnalysisByCategoryFailed
    extends FetchContestAnalysisByCategoryState {
  final String errorMessage;
  final Failure failure;
  
  const FetchContestAnalysisByCategoryFailed({
    required this.errorMessage,
    required this.failure,
  });

  @override
  List<Object> get props => [errorMessage];
}
