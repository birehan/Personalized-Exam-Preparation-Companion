import 'package:equatable/equatable.dart';
import 'sub_chapters_list.dart';

import '../../../chapter/domain/entities/chapter.dart';

class UserChapterAnalysis extends Equatable {
  final String id;
  final Chapter chapter;
  final int completedSubChapters;
  final List<SubChapterList> subchapters;

  const UserChapterAnalysis({
    required this.id,
    required this.chapter,
    required this.completedSubChapters,
    required this.subchapters,
  });
  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        chapter,
        completedSubChapters,
      ];
}
