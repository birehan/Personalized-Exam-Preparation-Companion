import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failure.dart';
import '../../../../features.dart';

part 'fetch_daily_streak_event.dart';
part 'fetch_daily_streak_state.dart';

class FetchDailyStreakBloc
    extends Bloc<FetchDailyStreakEvent, FetchDailyStreakState> {
  FetchDailyStreakBloc({
    required this.fetchDailyStreakUsecase,
  }) : super(FetchDailyStreakInitial()) {
    on<FetchDailyStreakEvent>(_onFetchDailyStreak);
  }

  final FetchDailyStreakUsecase fetchDailyStreakUsecase;

  void _onFetchDailyStreak(
      FetchDailyStreakEvent event, Emitter<FetchDailyStreakState> emit) async {
    emit(FetchDailyStreakLoading());
    final failureOrDailyStreak = await fetchDailyStreakUsecase(
      FetchDailyStreakParams(
        startDate: event.startDate,
        endDate: event.endDate,
      ),
    );
    emit(
      failureOrDailyStreak.fold(
        (failure) => FetchDailyStreakFailed(errorMessage: failure.errorMessage, failure: failure),
        (dailyStreak) => FetchDailyStreakLoaded(dailyStreak: dailyStreak),
      ),
    );
  }
}
