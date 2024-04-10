import 'package:equatable/equatable.dart';

class DailyQuizQuestion extends Equatable {
  final String id;
  final String description;
  final String choiceA;
  final String choiceB;
  final String choiceC;
  final String choiceD;
  final String? answer;
  final String? explanation;
  final String? chapterId;
  final String? courseId;
  final String? subChapterId;
  final String? relatedTopic;
  final bool? isLiked;
  final String? userId;
  final String? userAnswer;

  const DailyQuizQuestion({
    required this.id,
    required this.description,
    required this.choiceA,
    required this.choiceB,
    required this.choiceC,
    required this.choiceD,
    this.answer,
    this.explanation,
    this.chapterId,
    this.courseId,
    this.subChapterId,
    this.relatedTopic,
    this.isLiked,
    this.userId,
    this.userAnswer,
  });

  @override
  List<Object?> get props => [
        id,
        description,
        choiceA,
        choiceB,
        choiceC,
        choiceD,
        answer,
        explanation,
        chapterId,
        courseId,
        subChapterId,
        relatedTopic,
        isLiked,
        userId,
        userAnswer,
      ];
}
