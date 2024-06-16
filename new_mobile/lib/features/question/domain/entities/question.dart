import 'package:equatable/equatable.dart';

class Question extends Equatable {
  final String id;
  final String courseId;
  final String chapterId;
  final String subChapterId;
  final String description;
  final String choiceA;
  final String choiceB;
  final String choiceC;
  final String choiceD;
  final String answer;
  final String explanation;
  final bool isForQuiz;
  final bool isLiked;
  final String? relatedTopic;
  final String? userAnswer;

  const Question({
    required this.isLiked,
    required this.id,
    required this.courseId,
    required this.chapterId,
    required this.subChapterId,
    required this.description,
    required this.choiceA,
    required this.choiceB,
    required this.choiceC,
    required this.choiceD,
    required this.answer,
    required this.explanation,
    required this.isForQuiz,
    this.relatedTopic,
    this.userAnswer,
  });

  @override
  List<Object?> get props => [
        id,
        courseId,
        chapterId,
        subChapterId,
        description,
        choiceA,
        choiceB,
        choiceC,
        choiceD,
        answer,
        explanation,
        isForQuiz,
        relatedTopic,
        userAnswer,
      ];
}
