import 'package:skill_bridge_mobile/features/bookmarks/data/models/content_bookmarks_model.dart';
import 'package:skill_bridge_mobile/features/bookmarks/data/models/question_bookmarks_model.dart';
import 'package:skill_bridge_mobile/features/bookmarks/domain/domain.dart';

class BookmarksModel extends Bookmarks {
  const BookmarksModel({
    required super.bookmakredQuestions,
    required super.bookmarkedContents,
  });
  factory BookmarksModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> bookmarkedQuestionsjson = json['bookmarkedQuestions'];
    List<dynamic> bookmarkedContentsjson = json['bookmarkedContents'];

    // List<BookmarkedContentsModel> bookmarkedContent = [];
    // List<BookmarkedQuestionsModel> bookmarkedQuestions = [];

    // for (int i = 0; i < bookmarkedQuestionsjson.length; i++) {
    //   BookmarkedQuestionsModel bq =
    //       BookmarkedQuestionsModel.fromJson(bookmarkedQuestionsjson[i]);
    //   bookmarkedQuestions.add(bq);
    // }
    // for (int i = 0; i < bookmarkedContentsjson.length; i++) {
    //   BookmarkedContentsModel cnt =
    //       BookmarkedContentsModel.fromJson(bookmarkedContentsjson[i]);
    //   bookmarkedContent.add(cnt);
    // }

    List<BookmarkedContent> bookmarkedContent = bookmarkedContentsjson
        .map(
          (content) => BookmarkedContentsModel.fromJson(content),
        )
        .toList();
    List<BookmarkedQuestions> bookmarkedQuestions = bookmarkedQuestionsjson
        .map((bQuestion) => BookmarkedQuestionsModel.fromJson(bQuestion))
        .toList();

    return BookmarksModel(
        bookmakredQuestions: bookmarkedQuestions,
        bookmarkedContents: bookmarkedContent);
  }
}
