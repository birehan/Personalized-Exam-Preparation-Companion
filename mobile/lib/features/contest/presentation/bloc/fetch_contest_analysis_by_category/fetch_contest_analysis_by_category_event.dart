part of 'fetch_contest_analysis_by_category_bloc.dart';

class FetchContestAnalysisByCategoryEvent extends Equatable {
  const FetchContestAnalysisByCategoryEvent({
    required this.categoryId,
  });

  final String categoryId;

  @override
  List<Object> get props => [categoryId];
}
