import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/usecases/register_sub_chapter_usecase.dart';

part 'sub_chapter_regstration_event.dart';
part 'sub_chapter_regstration_state.dart';

class SubChapterRegstrationBloc
    extends Bloc<SubChapterRegstrationEvent, SubChapterRegstrationState> {
  final RegisterSubChapterUsecase registerSubChapterUsecase;
  SubChapterRegstrationBloc({required this.registerSubChapterUsecase})
      : super(SubChapterRegstrationInitial()) {
    on<ResgisterSubChpaterEvent>(_onSubChapterRegistration);
  }

  _onSubChapterRegistration(ResgisterSubChpaterEvent event,
      Emitter<SubChapterRegstrationState> emit) async {
    emit(SubChapterRegstrationLoadingState());
    Either<Failure, bool> response = await registerSubChapterUsecase(
        SubChapterRegistrationParams(
            chapterId: event.chapterId, subChapterid: event.subChapterid));
    emit(_eitherFailureOrBool(response));
  }

  SubChapterRegstrationState _eitherFailureOrBool(
      Either<Failure, bool> response) {
    return response.fold((failure) => SubChapterRegstrationFailedState(failure: failure),
        (bool) => SubChapterRegstrationSuccessState());
  }
}
