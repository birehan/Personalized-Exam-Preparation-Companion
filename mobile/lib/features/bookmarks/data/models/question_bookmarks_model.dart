import 'package:skill_bridge_mobile/features/bookmarks/domain/domain.dart';
import 'package:skill_bridge_mobile/features/features.dart';

class BookmarkedQuestionsModel extends BookmarkedQuestions {
  const BookmarkedQuestionsModel(
      {required super.question,
      required super.userAnswer,
      required super.isLiked,
      required super.bookmarkedTime});
  factory BookmarkedQuestionsModel.fromJson(Map<String, dynamic> json) {
    String updatedAtString = json[
        'updatedAt']; // Assuming 'updatedAt' is the datetime string from the backend.

    DateTime parsedTime;

    try {
      parsedTime = DateTime.parse(updatedAtString);
    } catch (e) {
      parsedTime = DateTime.now();
    }
    return BookmarkedQuestionsModel(
        isLiked: json['isLiked'] ?? false,
        question: QuestionModel.fromJson(json['question']),
        userAnswer: UserAnswerModel.fromJson(json['userAnswer']),
        bookmarkedTime: parsedTime);
  }
}
