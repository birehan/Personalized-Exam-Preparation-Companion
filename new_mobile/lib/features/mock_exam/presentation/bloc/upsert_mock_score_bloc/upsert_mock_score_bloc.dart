import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/core.dart';
import '../../../../features.dart';

part 'upsert_mock_score_event.dart';
part 'upsert_mock_score_state.dart';

class UpsertMockScoreBloc
    extends Bloc<UpsertMyMockScoreEvent, UpsertMockScoreState> {
  final UpsertMockScoreUsecase upsertMockScoreUsecase;

  UpsertMockScoreBloc({
    required this.upsertMockScoreUsecase,
  }) : super(UpsertMockScoreInitial()) {
    on<UpsertMyMockScoreEvent>(_onUpsertMockScore);
  }

  void _onUpsertMockScore(
      UpsertMyMockScoreEvent event, Emitter<UpsertMockScoreState> emit) async {
    emit(const UpsertMyMockScoreState(status: MockExamStatus.loading));
    final failureOrUpsertMockScore = await upsertMockScoreUsecase(
      UpsertMockScoreParams(
        mockId: event.mockId,
        score: event.score,
      ),
    );
    emit(_onUpsertMockScoreOrFailure(failureOrUpsertMockScore));
  }

  UpsertMockScoreState _onUpsertMockScoreOrFailure(
      Either<Failure, void> failureOrUpsertMockScore) {
    return failureOrUpsertMockScore.fold(
      (failure) => UpsertMyMockScoreState(status: MockExamStatus.error, failure: failure),
      (r) => const UpsertMyMockScoreState(status: MockExamStatus.loaded),
    );
  }
}
