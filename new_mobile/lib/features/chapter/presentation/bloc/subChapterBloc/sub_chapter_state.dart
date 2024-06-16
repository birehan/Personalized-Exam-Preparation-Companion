part of 'sub_chapter_bloc.dart';

abstract class SubChapterState extends Equatable {
  const SubChapterState();

  @override
  List<Object> get props => [];
}

class SubChapterInitial extends SubChapterState {}

class SubChapterLoadedState extends SubChapterState {
  final SubChapter subChapter;

  const SubChapterLoadedState({required this.subChapter});
}

class SubChapterLoadingState extends SubChapterState {}

class SubChapterFailedState extends SubChapterState {
  final String message;
  final Failure failure;

  const SubChapterFailedState({
    required this.message,
    required this.failure,
  });
}
