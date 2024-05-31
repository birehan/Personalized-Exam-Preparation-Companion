import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:skill_bridge_mobile/features/question/domain/usecases/get_end_chapter_questions_usecase.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/entities/end_subtopic_question_answer.dart';

part 'endof_chapter_questions_event.dart';
part 'endof_chapter_questions_state.dart';

class EndofChapterQuestionsBloc
    extends Bloc<EndofChapterQuestionsEvent, EndofChapterQuestionsState> {
  final GetEndOfChapterQuestionsUsecase getEndOfChapterQuestionsUsecase;
  EndofChapterQuestionsBloc({required this.getEndOfChapterQuestionsUsecase})
      : super(EndofChapterQuestionsInitial()) {
    on<EndOfChapterFetchedEvent>(onEndofChapterQuestionsFetched);
  }
  onEndofChapterQuestionsFetched(EndOfChapterFetchedEvent event,
      Emitter<EndofChapterQuestionsState> emit) async {
    emit(EndofChapterQuestionsLoadingState());
    Either<Failure, List<EndQuestionsAndAnswer>> response =
        await getEndOfChapterQuestionsUsecase(
            GetEndChapterQuestionsParams(chapterId: event.chapterId));
    EndofChapterQuestionsState state = response.fold(
        (failure) => EndofChapterQuestionsErrorState(errorMessage: failure.errorMessage, failure: failure),
        (questions) => EndofChapterQuestionsSuccessState(
            endSubtopicQuestionAnswers: questions));
    emit(state);
  }
}
