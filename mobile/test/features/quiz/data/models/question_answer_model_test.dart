import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:skill_bridge_mobile/features/question/question.dart';
import 'package:skill_bridge_mobile/features/quiz/data/models/question_answer_model.dart';
import 'package:skill_bridge_mobile/features/quiz/domain/entities/question_answer.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const question = QuestionModel(
      isLiked: false,
      id: "653cb1f54535227899808924",
      courseId: "635981f6e40f61599e000064",
      chapterId: "635981f6e40f61599e000064",
      subChapterId: "635981f6e40f61599e000064",
      description:
          "A company uses an arithmetic sequence to determine the salaries of its employees.",
      choiceA: "900,000",
      choiceB: "750,000",
      choiceC: "1,000,000",
      choiceD: "830,000",
      answer: "choice_C",
      explanation: "The sum of an arithmetic series is given by the formula",
      isForQuiz: false);
  const userAnswer = UserAnswerModel(
      userId: "6539339b0d8e1130915dc74d",
      questionId: "653cb1f54535227899808924",
      userAnswer: "choice_E");
  const questionAnswer =
      QuestionAnswerModel(question: question, userAnswer: userAnswer);

  test('should be a subclass of questionanswer entity', () async {
    // assert
    expect(questionAnswer, isA<QuestionAnswer>());
  });

  group('fromJson', () {
    test('should return a valid model when the JSON is recieved', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('quiz/question_answer.json'));
      // act
      final result = QuestionAnswerModel.fromJson(jsonMap);
      // assert
      expect(result, questionAnswer);
    });
  });
}