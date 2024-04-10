import 'sub_chapter_list_model.dart';

import 'models.dart';
import '../../domain/domain.dart';

class UserChapterAnalysisModel extends UserChapterAnalysis {
  const UserChapterAnalysisModel(
      {required super.id,
      required super.chapter,
      required super.completedSubChapters,
      required super.subchapters});

  factory UserChapterAnalysisModel.fromJson(Map<String, dynamic> json) {
    return UserChapterAnalysisModel(
        id: json['_id'],
        chapter: ChapterModel.fromJson(json['chapter']),
        completedSubChapters: json['completedSubChapters'],
        subchapters: (json['subChapters'] ?? [])
            .map<SubChapterListModel>(
                (subChapter) => SubChapterListModel.fromJson(subChapter))
            .toList());
  }
}
