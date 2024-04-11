import 'package:equatable/equatable.dart';

import 'sub_chapters_list.dart';

class SubChapters extends Equatable {
  final List<String> completedSubchapters;
  final List<SubChapterList> subChapterList;

  const SubChapters({
    required this.completedSubchapters,
    required this.subChapterList,
  });
  @override
  List<Object?> get props => [
        completedSubchapters,
        subChapterList,
      ];
}
