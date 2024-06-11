import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:prep_genie/features/features.dart';
import '../../../../fixtures/fixture_reader.dart';

void main() {
  DateTime dateTime = DateTime.parse("2024-03-13 10:24:57.572844");

  final dailyQuiz = DailyQuizModel(
      dailyQuizQuestions: [],
      description: "",
      id: "",
      userScore: 0,
      day: dateTime,
      departmentId: "",
      isSolved: false);
  const dailyQuizs = DailyQuizModel(
      dailyQuizQuestions: [],
      description: "",
      id: "",
      userScore: 1,
      userId: "");

  test('should be a subclass of daily quiz entity', () async {
    // assert
    expect(dailyQuiz, isA<DailyQuiz>());
  });

  group('fromJson', () {
    test('should return a valid model when the JSON is recieved', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('home/daily_quiz.json'));
      // act
      final result = DailyQuizModel.fromJson(jsonMap);
      // assert
      expect(result, dailyQuiz);
    });
  });

  group('fromAnalysisJson', () {
    test('should return a valid model when the JSON is recieved', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('home/daily_quiz.json'));
      // act
      final result = DailyQuizModel.fromAnalysisJson(jsonMap);
      // assert
      expect(result, dailyQuizs);
    });
  });
}
