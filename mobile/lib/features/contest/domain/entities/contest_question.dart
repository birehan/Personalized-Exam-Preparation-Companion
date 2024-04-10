import 'package:equatable/equatable.dart';

class ContestQuestion extends Equatable {
  final String id;
  final String contestCategoryId;
  final String chapterId;
  final String courseId;
  final String subChapterId;
  final String description;
  final String choiceA;
  final String choiceB;
  final String choiceC;
  final String choiceD;
  final String relatedTopic;
  final int difficulty;
  final String answer;
  final String explanation;
  final String userAnswer;

  const ContestQuestion({
    required this.id,
    required this.contestCategoryId,
    required this.chapterId,
    required this.courseId,
    required this.subChapterId,
    required this.description,
    required this.choiceA,
    required this.choiceB,
    required this.choiceC,
    required this.choiceD,
    required this.relatedTopic,
    required this.difficulty,
    required this.answer,
    required this.explanation,
    required this.userAnswer,
  });

  @override
  List<Object?> get props => [
        id,
        contestCategoryId,
        chapterId,
        courseId,
        subChapterId,
        description,
        choiceA,
        choiceB,
        choiceC,
        choiceD,
        relatedTopic,
        difficulty,
        answer,
        explanation,
        userAnswer,
      ];
}
