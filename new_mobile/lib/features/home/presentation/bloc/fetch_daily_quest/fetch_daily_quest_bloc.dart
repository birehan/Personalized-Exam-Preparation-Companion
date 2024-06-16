import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/core.dart';
import '../../../../features.dart';

part 'fetch_daily_quest_event.dart';
part 'fetch_daily_quest_state.dart';

class FetchDailyQuestBloc
    extends Bloc<FetchDailyQuestEvent, FetchDailyQuestState> {
  FetchDailyQuestBloc({
    required this.fetchDailyQuestUsecase,
  }) : super(FetchDailyQuestInitial()) {
    on<FetchDailyQuestEvent>(_onFetchDailyQuest);
  }

  final FetchDailyQuestUsecase fetchDailyQuestUsecase;

  void _onFetchDailyQuest(
      FetchDailyQuestEvent event, Emitter<FetchDailyQuestState> emit) async {
    emit(FetchDailyQuestLoading());

    final failureOrDailyQuest = await fetchDailyQuestUsecase(NoParams());
    emit(
      failureOrDailyQuest.fold(
        (failure) => FetchDailyQuestFailed(errorMessage: failure.errorMessage, failure: failure),
        (dailyQuests) => FetchDailyQuestLoaded(dailyQuests: dailyQuests),
      ),
    );
  }
}
