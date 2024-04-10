part of 'sub_chapter_bloc.dart';

abstract class SubChapterEvent extends Equatable {
  const SubChapterEvent();

  @override
  List<Object> get props => [];
}

class GetSubChapterContentsEvent extends SubChapterEvent {
  final String subChapterId;

  const GetSubChapterContentsEvent({required this.subChapterId});
}
