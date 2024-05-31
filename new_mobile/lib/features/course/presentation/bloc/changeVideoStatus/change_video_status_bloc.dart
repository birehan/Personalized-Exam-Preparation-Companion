import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:skill_bridge_mobile/features/course/domain/usecases/update_video_status_usecase.dart';

part 'change_video_status_event.dart';
part 'change_video_status_state.dart';

class ChangeVideoStatusBloc
    extends Bloc<ChangeVideoStatusEvent, ChangeVideoStatusState> {
  final UpdateVideoStatusUsecase updateVideoStatusUsecase;
  ChangeVideoStatusBloc({required this.updateVideoStatusUsecase})
      : super(ChangeVideoStatusInitial()) {
    on<ChangeSingleVideoStatusEvent>((event, emit) async {
      emit(ChangeVideoStatusLoading());

      final response = await updateVideoStatusUsecase(UpdateVideoStatusParams(
          videoId: event.videoId, isCompleted: event.isCompleted));
      final state = response.fold(
          (l) => ChangeVideoStatusFailed(), (r) => VideoStatusChangedState());
      emit(state);
    });
  }
}
