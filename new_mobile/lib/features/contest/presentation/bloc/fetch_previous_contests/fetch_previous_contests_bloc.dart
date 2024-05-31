import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:skill_bridge_mobile/core/core.dart';

import '../../../../features.dart';

part 'fetch_previous_contests_event.dart';
part 'fetch_previous_contests_state.dart';

class FetchPreviousContestsBloc
    extends Bloc<FetchPreviousContestsEvent, FetchPreviousContestsState> {
  FetchPreviousContestsBloc({
    required this.fetchAllContestsUsecase,
  }) : super(FetchPreviousContestsInitial()) {
    on<FetchPreviousContestsEvent>(_onFetchPreviousContests);
  }

  final FetchPreviousContestsUsecase fetchAllContestsUsecase;

  void _onFetchPreviousContests(
      FetchPreviousContestsEvent event, Emitter<FetchPreviousContestsState> emit) async {
    emit(FetchPreviousContestsLoading());
    final failureOrContests = await fetchAllContestsUsecase(NoParams());
    emit(
      failureOrContests.fold(
        (failure) => FetchPreviousContestsFailed(failure: failure),
        (contests) => FetchPreviousContestsLoaded(contests: contests),
      ),
    );
  }
}
