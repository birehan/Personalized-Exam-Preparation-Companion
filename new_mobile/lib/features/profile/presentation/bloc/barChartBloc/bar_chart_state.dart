part of 'bar_chart_bloc.dart';

class BarChartState extends Equatable {
  const BarChartState();

  @override
  List<Object> get props => [];
}

class BarChartInitial extends BarChartState {}

class BarChartDataLoadingState extends BarChartState {}

class BarChartDataLoadedState extends BarChartState {
  final ScoreCategoryListEntity categories;

  const BarChartDataLoadedState({required this.categories});
}

class BarChartDataLoadFailedState extends BarChartState {
  final Failure failure;

  const BarChartDataLoadFailedState({required this.failure});
}
