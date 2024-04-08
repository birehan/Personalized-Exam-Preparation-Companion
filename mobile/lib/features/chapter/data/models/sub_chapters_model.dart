import '../../domain/entities/sub_chapters_entity.dart';
import '../../domain/entities/sub_chapters_list.dart';
import 'sub_chapter_list_model.dart';

class SubChaptersModel extends SubChapters {
  const SubChaptersModel({
    required super.completedSubchapters,
    required super.subChapterList,
  });

  factory SubChaptersModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> subChaptersJson = json['subChapters'];
    List<SubChapterList> subChapters = subChaptersJson
        .map((subChapter) => SubChapterListModel.fromJson(subChapter))
        .toList();
    List<String> completeChapters = (json['completedSubChapters'] ?? [])
        .map<String>((completedSubChapter) => completedSubChapter as String)
        .toList();
    return SubChaptersModel(
      subChapterList: subChapters,
      completedSubchapters: completeChapters,
    );
  }
}
