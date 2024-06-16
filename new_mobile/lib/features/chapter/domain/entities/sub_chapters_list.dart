import 'package:equatable/equatable.dart';

class SubChapterList extends Equatable {
  final String id;
  final String chapterId;
  final String subChapterName;
  final bool isCompleted;

  const SubChapterList({
    required this.id,
    required this.chapterId,
    required this.subChapterName,
    required this.isCompleted,
  });
  @override
  List<Object?> get props => [id, chapterId, subChapterName, isCompleted];
}
