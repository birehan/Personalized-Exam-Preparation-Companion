import '../../domain/entities/sub_chapters_list.dart';

class SubChapterListModel extends SubChapterList {
  const SubChapterListModel(
      {required super.id,
      required super.chapterId,
      required super.subChapterName,
      required super.isCompleted});
  factory SubChapterListModel.fromJson(Map<String, dynamic> json) {
    return SubChapterListModel(
        id: json['_id'],
        chapterId: json['chapterId'],
        subChapterName: json['name'],
        isCompleted: json['isCompleted']);
  }
}
