import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:skill_bridge_mobile/core/core.dart';
import 'package:skill_bridge_mobile/features/features.dart';

part 'fetch_upcoming_user_contest_event.dart';
part 'fetch_upcoming_user_contest_state.dart';

class FetchUpcomingUserContestBloc
    extends Bloc<FetchUpcomingUserContestEvent, FetchUpcomingUserContestState> {
  final FetchUpcomingUserContestUsecase fetchUpcomingUserContestUsecase;
  FetchUpcomingUserContestBloc({required this.fetchUpcomingUserContestUsecase})
      : super(FetchUpcomingUserContestInitial()) {
    on<FetchUpcomingContestEvent>((event, emit) async {
      emit(UpcomingContestLoadingState());
      final Either<Failure, Contest?> result =
          await fetchUpcomingUserContestUsecase(NoParams());

      result.fold(
        (failure) => emit(UpcomingContestFailredState(failureType: failure)),
        (contest) => emit(UpcomingContestFetchedState(upcomingContes: contest)),
      );
    });
  }
}
