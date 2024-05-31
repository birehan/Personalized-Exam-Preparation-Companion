part of 'chapter_bloc.dart';

abstract class ChapterEvent extends Equatable {
  const ChapterEvent();

  @override
  List<Object> get props => [];
}

class GetSubChaptersEvent extends ChapterEvent {
  final String id;

  const GetSubChaptersEvent({required this.id});
}

class GetChapterByCourseIdEvent extends ChapterEvent {
  final String courseId;

  const GetChapterByCourseIdEvent({
    required this.courseId,
  });

  @override
  List<Object> get props => [courseId];
}
