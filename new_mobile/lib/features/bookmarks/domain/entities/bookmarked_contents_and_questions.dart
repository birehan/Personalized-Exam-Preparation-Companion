import 'package:equatable/equatable.dart';
import 'package:prep_genie/features/bookmarks/domain/entities/bookmarked_contents.dart';
import 'package:prep_genie/features/bookmarks/domain/entities/bookmarked_questions.dart';

class Bookmarks extends Equatable {
  const Bookmarks(
      {required this.bookmakredQuestions, required this.bookmarkedContents});
  final List<BookmarkedQuestions> bookmakredQuestions;
  final List<BookmarkedContent> bookmarkedContents;

  @override
  List<Object?> get props => [bookmakredQuestions, bookmarkedContents];
}
