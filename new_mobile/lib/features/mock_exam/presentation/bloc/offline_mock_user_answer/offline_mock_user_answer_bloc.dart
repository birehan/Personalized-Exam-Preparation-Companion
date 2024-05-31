import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:skill_bridge_mobile/features/mock_exam/mock_exam.dart';

import '../../../../../core/core.dart';
import '../../../../features.dart';

part 'offline_mock_user_answer_event.dart';
part 'offline_mock_user_answer_state.dart';

class OfflineMockUserAnswerBloc
    extends Bloc<OfflineMockUserAnswerEvent, OfflineMockUserAnswerState> {
  OfflineMockUserAnswerBloc({
    required this.upsertOfflineMockUserAnswerUsecase,
  }) : super(OfflineMockUserAnswerInitial()) {
    on<OfflineMockUserAnswerEvent>((event, emit) async {
      emit(OfflineMockUserAnswerLoading());
      final failureOrSuccess = await upsertOfflineMockUserAnswerUsecase(
        UpsertOfflineMockUserAnswerParams(
          mockId: event.mockId,
          userAnswers: event.userAnswers,
        ),
      );
      emit(
        failureOrSuccess.fold(
          (l) => OfflineMockUserAnswerFailed(failure: l),
          (isMockDownloaded) => OfflineMockUserAnswerLoaded(),
        ),
      );
    });
  }

  final UpsertOfflineMockUserAnswerUsecase upsertOfflineMockUserAnswerUsecase;
}
