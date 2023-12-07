part of 'sub_chapter_regstration_bloc.dart';

abstract class SubChapterRegstrationEvent extends Equatable {
  const SubChapterRegstrationEvent();

  @override
  List<Object> get props => [];
}

class ResgisterSubChpaterEvent extends SubChapterRegstrationEvent {
  final String chapterId;
  final String subChapterid;

  const ResgisterSubChpaterEvent(
      {required this.chapterId, required this.subChapterid});

  @override
  List<Object> get props => [chapterId, subChapterid];
}
