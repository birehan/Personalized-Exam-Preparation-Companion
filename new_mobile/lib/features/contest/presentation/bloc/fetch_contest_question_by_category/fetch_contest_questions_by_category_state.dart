part of 'fetch_contest_questions_by_category_bloc.dart';

class FetchContestQuestionsByCategoryState extends Equatable {
  const FetchContestQuestionsByCategoryState();

  @override
  List<Object> get props => [];
}

class FetchContestQuestionsByCategoryInitial
    extends FetchContestQuestionsByCategoryState {}

class FetchContestQuestionsByCategoryLoading
    extends FetchContestQuestionsByCategoryState {}

class FetchContestQuestionsByCategoryLoaded
    extends FetchContestQuestionsByCategoryState {
  final List<ContestQuestion> contestQuestions;

  const FetchContestQuestionsByCategoryLoaded({
    required this.contestQuestions,
  });

  @override
  List<Object> get props => [contestQuestions];
}

class FetchContestQuestionsByCategoryFailed
    extends FetchContestQuestionsByCategoryState {
    final Failure failure;

    const FetchContestQuestionsByCategoryFailed({
      required this.failure,
    });


    // @override
    // List<Object> get props => [errorMessage];
}
