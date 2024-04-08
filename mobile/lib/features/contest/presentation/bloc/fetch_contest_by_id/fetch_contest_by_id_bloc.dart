import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../features.dart';

part 'fetch_contest_by_id_event.dart';
part 'fetch_contest_by_id_state.dart';

class FetchContestByIdBloc
    extends Bloc<FetchContestByIdEvent, FetchContestByIdState> {
  FetchContestByIdBloc({
    required this.fetchContestByIdUsecase,
  }) : super(FetchContestByIdInitial()) {
    on<FetchContestByIdEvent>(_onFetchContestById);
  }

  final FetchContestByIdUsecase fetchContestByIdUsecase;

  void _onFetchContestById(
      FetchContestByIdEvent event, Emitter<FetchContestByIdState> emit) async {
    emit(FetchContestByIdLoading());
    final failureOrContest = await fetchContestByIdUsecase(
      FetchContestByIdParams(contestId: event.contestId),
    );
    emit(
      failureOrContest.fold(
        (l) => FetchContestByIdFailed(),
        (contest) => FetchContestByIdLoaded(contest: contest),
      ),
    );
  }
}
