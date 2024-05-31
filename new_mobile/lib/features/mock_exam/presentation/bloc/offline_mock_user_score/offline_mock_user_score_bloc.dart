import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:skill_bridge_mobile/features/features.dart';

import '../../../../../core/core.dart';

part 'offline_mock_user_score_event.dart';
part 'offline_mock_user_score_state.dart';

class OfflineMockUserScoreBloc
    extends Bloc<OfflineMockUserScoreEvent, OfflineMockUserScoreState> {
  OfflineMockUserScoreBloc({required this.upsertOfflineMockScoreUsecase}) : super(OfflineMockUserScoreInitial()) {
    on<OfflineMockUserScoreEvent>((event, emit) async {
      emit(OfflineMockUserScoreLoading());
      final failureOrSuccess = await upsertOfflineMockScoreUsecase(
        UpsertOfflineMockScoreParams(
          mockId: event.mockId,
          score: event.score,
          isCompleted: event.isCompleted,
        ),
      );
      emit(
        failureOrSuccess.fold(
          (l) => OfflineMockUserScoreFailed(failure: l),
          (isMockDownloaded) => OfflineMockUserScoreLoaded(),
        ),
      );
    });
  }

  final UpsertOfflineMockScoreUsecase upsertOfflineMockScoreUsecase;
}
