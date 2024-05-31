import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/core.dart';
import '../../../../features.dart';

part 'fetch_previous_user_contests_event.dart';
part 'fetch_previous_user_contests_state.dart';

class FetchPreviousUserContestsBloc
    extends Bloc<FetchPreviousUserContestsEvent, FetchPreviousUserContestsState> {
  FetchPreviousUserContestsBloc({
    required this.fetchUserContestsUsecase,
  }) : super(FetchPreviousUserContestsInitial()) {
    on<FetchPreviousUserContestsEvent>(_onFetchPreviousUserContests);
  }

  final FetchPreviousUserContestsUsecase fetchUserContestsUsecase;

  void _onFetchPreviousUserContests(FetchPreviousUserContestsEvent event,
      Emitter<FetchPreviousUserContestsState> emit) async {
    emit(FetchPreviousUserContestsLoading());
    final failureOrContest = await fetchUserContestsUsecase(NoParams());
    emit(
      failureOrContest.fold(
        (failure) => FetchPreviousUserContestsFailed(failure: failure),
        (contests) => FetchPreviousUserContestsLoaded(contests: contests),
      ),
    );
  }
}
