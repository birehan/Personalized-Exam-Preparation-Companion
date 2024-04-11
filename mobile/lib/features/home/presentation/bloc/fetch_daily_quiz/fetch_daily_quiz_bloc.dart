import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:skill_bridge_mobile/core/core.dart';

import '../../../../features.dart';

part 'fetch_daily_quiz_event.dart';
part 'fetch_daily_quiz_state.dart';

class FetchDailyQuizBloc
    extends Bloc<FetchDailyQuizEvent, FetchDailyQuizState> {
  FetchDailyQuizBloc({
    required this.fetchDailyQuizUsecase,
  }) : super(FetchDailyQuizInitial()) {
    on<FetchDailyQuizEvent>(_onFetchDailyQuiz);
  }

  final FetchDailyQuizUsecase fetchDailyQuizUsecase;

  void _onFetchDailyQuiz(
      FetchDailyQuizEvent event, Emitter<FetchDailyQuizState> emit) async {
    emit(FetchDailyQuizLoading());
    final failureOrDailyQuiz = await fetchDailyQuizUsecase(NoParams());
    emit(
      failureOrDailyQuiz.fold(
        (l) => FetchDailyQuizFailed(errorMessage: l.errorMessage),
        (dailyQuiz) => FetchDailyQuizLoaded(dailyQuiz: dailyQuiz),
      ),
    );
  }
}
