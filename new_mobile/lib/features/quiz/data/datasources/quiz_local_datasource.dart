import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

abstract class QuizLocalDatasource {
  Future<void> cacheQuiz(dynamic quiz, String id);
  Future<List<QuizModel>?> getQuiz(String id);
  Future<void> cacheQuizQuestions(dynamic quiz, String id);
  Future<QuizQuestionModel?> getQuizQuestions(String id);
}

class QuizLocalDatasourceImpl extends QuizLocalDatasource {
  final _quizBox = Hive.box(quizBox);

  @override
  Future<void> cacheQuiz(dynamic quiz, String id) async {
    await _quizBox.put('quiz-$id', quiz);
  }

  @override
  Future<List<QuizModel>?> getQuiz(String id) async {
    try {
      final rawData = await _quizBox.get('quiz-$id');
      if (rawData != null) {
        final data = json.decode(rawData)['data']['quizzes'];
        return data
            .map<QuizModel>((quizModel) => QuizModel.fromJson(quizModel))
            .toList();
      }
      return null;
    } catch (e) {
      print(e.toString());
      throw CacheException();
    }
  }

  @override
  Future<void> cacheQuizQuestions(dynamic quiz, String id) async {
    await _quizBox.put('quizQuestions-$id', quiz);
  }

  @override
  Future<QuizQuestionModel?> getQuizQuestions(String id) async {
    try {
      final rawData = await _quizBox.get('quizQuestions-$id');
      if (rawData != null) {
        final data = json.decode(rawData)['data'];
        return QuizQuestionModel.fromJson(data);
      }
      return null;
    } catch (e) {
      print(e.toString());
      throw CacheException();
    }
  }
}
