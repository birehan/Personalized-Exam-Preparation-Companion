part of 'chapter_bloc.dart';

abstract class ChapterState extends Equatable {
  const ChapterState();

  @override
  List<Object> get props => [];
}

class ChapterInitial extends ChapterState {}

class SubChaptersLoadedState extends ChapterState {
  final SubChapters subChapters;

  const SubChaptersLoadedState({required this.subChapters});
}

class SubChaptersLoadingState extends ChapterState {}

class SubChaptersFailedState extends ChapterState {
  final String message;

  const SubChaptersFailedState({required this.message});
}

enum ChapterStatus { loading, loaded, error }

class GetChapterByCourseIdState extends ChapterState {
  final ChapterStatus status;
  final List<Chapter>? chapters;
  final String? errorMessage;
  const GetChapterByCourseIdState({
    this.errorMessage,
    required this.status,
    this.chapters,
  });

  @override
  List<Object> get props => [status];
}
