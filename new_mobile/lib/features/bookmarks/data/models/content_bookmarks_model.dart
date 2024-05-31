import 'package:skill_bridge_mobile/features/bookmarks/domain/domain.dart';
import 'package:skill_bridge_mobile/features/chapter/data/data.dart';

class BookmarkedContentsModel extends BookmarkedContent {
  const BookmarkedContentsModel(
      {required super.id,
      required super.userId,
      required super.content,
      required super.bookmarkedTime});
  factory BookmarkedContentsModel.fromJson(Map<String, dynamic> json) {
    String updatedAtString = json[
        'updatedAt']; // Assuming 'updatedAt' is the datetime string from the backend.

    DateTime parsedTime;

    try {
      parsedTime = DateTime.parse(updatedAtString);
    } catch (e) {
      parsedTime = DateTime.now();
    }

    return BookmarkedContentsModel(
        content: ContentModel.fromJson(json['contentId']),
        id: json['_id'] ?? '',
        userId: json['userId'] ?? '',
        bookmarkedTime: parsedTime);
  }
}
