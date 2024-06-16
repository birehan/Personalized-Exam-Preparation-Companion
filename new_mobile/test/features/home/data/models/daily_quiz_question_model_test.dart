import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:prep_genie/features/features.dart';
import '../../../../fixtures/fixture_reader.dart';

void main() {
  const dailyQuizQuestion = DailyQuizQuestionModel(
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
      userId: "",
      userAnswer: "",
      relatedTopic: "");

  const dailyQuizQuestions = DailyQuizQuestionModel(
    id: "653cb1f54535227899808924",
    description:
        "A company uses an arithmetic sequence to determine the salaries of its employees.",
    choiceA: "900,000",
    choiceB: "750,000",
    choiceC: "1,000,000",
    choiceD: "830,000",
  );

  test('should be a subclass of daily quiz entity', () async {
    // assert
    expect(dailyQuizQuestion, isA<DailyQuizQuestion>());
  });

  group('fromJson', () {
    test('should return a valid model when the JSON is recieved', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('home/daily_quiz_question.json'));
      // act
      final result = DailyQuizQuestionModel.fromJson(jsonMap);
      // assert
      expect(result, dailyQuizQuestions);
    });
  });

  group('fromAnalysisJson', () {
    test('should return a valid model when the JSON is recieved', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('home/daily_quiz_question.json'));
      // act
      Map<String, dynamic> newJson = {
        'question': jsonMap,
        "userAnswer": {"userId": "", "userAnswer": ""}
      };
      final result = DailyQuizQuestionModel.fromAnalysisJson(newJson);
      // assert
      expect(result, dailyQuizQuestion);
    });
  });
}
