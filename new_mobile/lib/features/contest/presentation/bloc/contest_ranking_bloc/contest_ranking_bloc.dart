import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:prep_genie/core/core.dart';
import 'package:prep_genie/features/contest/domain/usecases/contest_ranking_usercase.dart';

import '../../../../features.dart';

part 'contest_ranking_event.dart';
part 'contest_ranking_state.dart';

class ContestRankingBloc
    extends Bloc<ContestRankingEvent, ContestRankingState> {
  final GetContestRankingUsecase getContestRankingUsecase;
  ContestRankingBloc({required this.getContestRankingUsecase})
      : super(ContestRankingInitial()) {
    on<GetContestRankingEvent>((event, emit) async {
      emit(ContestRankingLoadingState());
      final result = await getContestRankingUsecase(
          ContestRankingParams(contestId: event.contestId));
      result.fold(
        (failure) => emit(ContestRankingFailedState(failureType: failure)),
        (ranking) => emit(ContestRankingLoadedState(ranking: ranking)),
      );
    });
  }
}
