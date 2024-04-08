part of 'fetch_contest_questions_by_category_bloc.dart';

class FetchContestQuestionsByCategoryEvent extends Equatable {
  const FetchContestQuestionsByCategoryEvent({required this.categoryId});

  final String categoryId;

  @override
  List<Object> get props => [categoryId];
}
