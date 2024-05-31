part of 'fetch_daily_quest_bloc.dart';

class FetchDailyQuestState extends Equatable {
  const FetchDailyQuestState();

  @override
  List<Object> get props => [];
}

class FetchDailyQuestInitial extends FetchDailyQuestState {}

class FetchDailyQuestLoading extends FetchDailyQuestState {}

class FetchDailyQuestLoaded extends FetchDailyQuestState {
  const FetchDailyQuestLoaded({
    required this.dailyQuests,
  });

  final List<DailyQuest> dailyQuests;

  @override
  List<Object> get props => [dailyQuests];
}

class FetchDailyQuestFailed extends FetchDailyQuestState {
  final Failure failure;
  final String errorMessage;

  const FetchDailyQuestFailed({
    required this.errorMessage,
    required this.failure,
  });

  @override
  List<Object> get props => [errorMessage];
}
