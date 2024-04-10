part of 'endof_chapter_questions_bloc.dart';

class EndofChapterQuestionsEvent extends Equatable {
  const EndofChapterQuestionsEvent();

  @override
  List<Object> get props => [];
}

class EndOfChapterFetchedEvent extends EndofChapterQuestionsEvent {
  final String chapterId;

  const EndOfChapterFetchedEvent({required this.chapterId});
  @override
  List<Object> get props => [chapterId];
}
