import 'package:prep_genie/features/bookmarks/data/models/content_bookmarks_model.dart';
import 'package:prep_genie/features/bookmarks/data/models/question_bookmarks_model.dart';
import 'package:prep_genie/features/bookmarks/domain/domain.dart';

class BookmarksModel extends Bookmarks {
  const BookmarksModel({
    required super.bookmakredQuestions,
    required super.bookmarkedContents,
  });
  factory BookmarksModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> bookmarkedQuestionsjson = json['bookmarkedQuestions'];
    List<dynamic> bookmarkedContentsjson = json['bookmarkedContents'];


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
