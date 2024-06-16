import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/constants/app_keys.dart';
import '../../../../core/core.dart';
import '../../../features.dart';
import 'package:http/http.dart' as http;

abstract class QuizRemoteDataSource {
  Future<List<QuizModel>> getQuizByCourseId(String courseId);
  Future<String> createQuiz({
    required String name,
    required List<String> chapters,
    required int numberOfQuestion,
    required String courseId,
  });
  Future<QuizQuestionModel> getQuizById(String quizId);
  Future<void> saveQuizScore({
    required String quizId,
    required int score,
  });
}

class QuizRemoteDataSourceImpl implements QuizRemoteDataSource {
  final http.Client client;
  final FlutterSecureStorage flutterSecureStorage;
  final QuizLocalDatasource localDatasource;

  QuizRemoteDataSourceImpl({
    required this.client,
    required this.flutterSecureStorage,
    required this.localDatasource,
  });

  @override
  Future<List<QuizModel>> getQuizByCourseId(String courseId) async {
    final userModel = await flutterSecureStorage.read(key: authenticationKey);

    if (userModel == null) {
      throw UnauthorizedRequestException();
    }

    final userModelJson = json.decode(userModel);
    final token = userModelJson['token'];

    try {
      final response = await client.get(
        Uri.parse('$baseUrl/quiz/userQuiz/$courseId'),
        headers: {
          'content-Type': 'application/json',
          'authorization': 'Bearer $token'
        },
      );
      if (response.statusCode == 200) {
        await localDatasource.cacheQuiz(response.body, courseId);
        final data = json.decode(response.body)['data']['quizzes'];

        return data
            .map<QuizModel>(
              (quiz) => QuizModel.fromJson(quiz),
            )
            .toList();
      } else if (response.statusCode == 429) {
        throw RequestOverloadException(errorMessage: 'Too Many Request');
      } else {
        throw ServerException();
      }
    } catch (e) {
      if (e is RequestOverloadException) {
        throw e;
      }
      throw ServerException();
    }
  }

  @override
  Future<String> createQuiz({
    required String name,
    required List<String> chapters,
    required int numberOfQuestion,
    required String courseId,
  }) async {
    final userCredential =
        await flutterSecureStorage.read(key: authenticationKey);

    if (userCredential == null) {
      throw UnauthorizedRequestException();
    }

    final token = json.decode(userCredential)['token'];

    final payload = json.encode({
      'name': name,
      'chapters': chapters,
      'numOfQuestion': numberOfQuestion,
      'courseId': courseId,
    });

    final response = await client.post(
      Uri.parse('$baseUrl/quiz'),
      body: payload,
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body)['data']['newQuiz'];
      return data['_id'];
    } else if (response.statusCode == 500) {
      final errorMessage = json.decode(response.body)['message'];
      throw CreateQuizException(errorMessage: errorMessage);
    } else if (response.statusCode == 429) {
      throw RequestOverloadException(errorMessage: 'Too Many Request');
    }
    throw ServerException();
  }

  @override
  Future<QuizQuestionModel> getQuizById(String quizId) async {
    final userCredential =
        await flutterSecureStorage.read(key: authenticationKey);
    if (userCredential == null) {
      throw UnauthorizedRequestException();
    }

    final token = json.decode(userCredential)['token'];

    final response = await client.get(
      Uri.parse('$baseUrl/quiz/$quizId'),
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      await localDatasource.cacheQuizQuestions(
        response.body,
        quizId,
      );
      final data = json.decode(response.body)['data'];
      return QuizQuestionModel.fromJson(data);
    } else if (response.statusCode == 429) {
      throw RequestOverloadException(errorMessage: 'Too Many Request');
    }
    throw ServerException();
  }

  @override
  Future<void> saveQuizScore({
    required String quizId,
    required int score,
  }) async {
    final userCredential =
        await flutterSecureStorage.read(key: authenticationKey);
    if (userCredential == null) {
      throw UnauthorizedRequestException();
    }

    final token = json.decode(userCredential)['token'];

    final payload = json.encode({
      'quizId': quizId,
      'score': score,
    });

    final response = await client.post(
      Uri.parse('$baseUrl/userQuizScore'),
      body: payload,
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 201) {
      return;
    } else if (response.statusCode == 429) {
      throw RequestOverloadException(errorMessage: 'Too Many Request');
    }
    throw ServerException();
  }
}
