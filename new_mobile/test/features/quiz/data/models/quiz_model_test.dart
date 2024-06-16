import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:prep_genie/features/question/data/models/question_model.dart';
import 'package:prep_genie/features/quiz/quiz.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const question = [
    QuestionModel(
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
        isForQuiz: false)
  ];
  const quizModel = QuizModel(
      id: "65409f8955ae50031e35169f",
      name: "SAT Entrance Exam 1",
      userId: "6539339b0d8e1130915dc74d",
      chapterIds: ["635981f6e40f61599e000064", "635981f6e40f61599e000064"],
      courseId: "6539339b0d8e1130915dc74d",
      score: 5,
      isComplete: true,
      questionIds: ["653cb1f54535227899808924"]);

  const quizModelById = QuizModel(
      id: "65409f8955ae50031e35169f",
      name: "SAT Entrance Exam 1",
      userId: "6539339b0d8e1130915dc74d",
      chapterIds: ["635981f6e40f61599e000064", "635981f6e40f61599e000064"],
      courseId: "6539339b0d8e1130915dc74d",
      score: 5,
      isComplete: true,
      questions: question);

  test('should be a subclass of questionanswer entity', () async {
    // assert
    expect(quizModelById, isA<Quiz>());
    expect(quizModel, isA<Quiz>());
  });

  group('fromJson', () {
    test('should return a valid model when the JSON is recieved', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('quiz/quiz.json'));
      // act
      final result = QuizModel.fromJson(jsonMap);
      // assert
      expect(result, quizModel);
    });
  });
 
 
  group('toJson', () {
    test('should return a Json map containing the proper data', () async {
      // act
      final result = quizModel.toJson();
      // assert
      final expectedJsonMap = {
        "_id": "65409f8955ae50031e35169f",
        "name": "SAT Entrance Exam 1",
        "userId": "6539339b0d8e1130915dc74d",
        "courseId": "6539339b0d8e1130915dc74d",
        "chapterId": ["635981f6e40f61599e000064", "635981f6e40f61599e000064"],
        "questionIds": ["653cb1f54535227899808924"],
        "score": 5,
        "completed": true,
        "question": null
      };
      expect(result, expectedJsonMap);
    });
  });
}
