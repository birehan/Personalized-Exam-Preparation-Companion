import 'package:equatable/equatable.dart';
import 'package:skill_bridge_mobile/features/features.dart';

class BookmarkedQuestions extends Equatable {
  final Question question;
  final UserAnswer userAnswer;
  final bool isLiked;
  final DateTime bookmarkedTime;

  const BookmarkedQuestions({
    required this.question,
    required this.bookmarkedTime,
    required this.userAnswer,
    required this.isLiked,
  });

  @override
  List<Object?> get props => [question, userAnswer, isLiked, bookmarkedTime];
}
