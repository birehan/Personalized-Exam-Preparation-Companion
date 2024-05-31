import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/usecases/bookmark_question_usecase.dart';

part 'add_question_bookmark_event.dart';
part 'add_question_bookmark_state.dart';

class AddQuestionBookmarkBloc
    extends Bloc<AddQuestionBookmarkEvent, AddQuestionBookmarkState> {
  final QuestionBookmarkUsecase questionBookmarkUsecase;
  AddQuestionBookmarkBloc({required this.questionBookmarkUsecase})
      : super(AddQuestionBookmarkInitial()) {
    on<QuestionBookmarkAddedEvent>(onQuestionBookmarkAdded);
  }
  onQuestionBookmarkAdded(QuestionBookmarkAddedEvent event,
      Emitter<AddQuestionBookmarkState> emit) async {
    emit(AddQuestionBookmarkAddingState());
    Either<Failure, void> response = await questionBookmarkUsecase(
        QuestionBookmarkParams(questionId: event.questionId));

    AddQuestionBookmarkState state = response.fold(
        (l) => AddQuestionBookmarkErrorState(),
        (r) => AddQuestionBookmarkSuccessState());
    emit(state);
  }
}
