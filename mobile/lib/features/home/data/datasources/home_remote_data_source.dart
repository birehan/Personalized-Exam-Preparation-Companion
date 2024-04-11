import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../../../core/constants/app_keys.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

abstract class HomeRemoteDatasource {
  Future<List<UserCourse>> getMyCourses();
  Future<List<ExamDateModel>> getExamDate();
  Future<HomeModel> getHomeContent();
  Future<DailyStreakModel> fetchDailyStreak(
    DateTime startDate,
    DateTime endDate,
  );
  Future<DailyQuizModel> fetchDailyQuiz();
  Future<DailyQuizModel> fetchDailyQuizForAnalysis(String id);
  Future<void> submitDailyQuizAnswer(DailyQuizAnswer dailyQuizAnswer);
  Future<List<DailyQuestModel>> fetchDailyQuest();
}

class HomeRemoteDatasourceImpl implements HomeRemoteDatasource {
  final http.Client client;
  final FlutterSecureStorage flutterSecureStorage;
  final HomeLocalDatasource homeLocalDatasource;
  HomeRemoteDatasourceImpl({
    required this.client,
    required this.flutterSecureStorage,
    required this.homeLocalDatasource,
  });

  @override
  Future<List<ExamDateModel>> getExamDate() async {
    final response = await client.get(
      Uri.parse('$baseUrl/examDate'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data']['examDates'];
      return data
          .map<ExamDateModel>(
            (examDate) => ExamDateModel.fromJson(examDate),
          )
          .toList();
    }
    throw ServerException();
  }

  @override
  Future<List<UserCourse>> getMyCourses() async {
    final userModel = await flutterSecureStorage.read(key: authenticationKey);

    if (userModel == null) {
      throw UnauthorizedRequestException();
    }

    final userModelJson = json.decode(userModel);
    final token = userModelJson['token'];

    final response = await client.get(
      Uri.parse('$baseUrl/userCourse'),
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data']['userCourses'];

      return data
          .map<UserCourse>((userCourse) => UserCourseModel.fromJson(userCourse))
          .toList();
    }
    throw ServerException();
  }

  @override
  Future<HomeModel> getHomeContent() async {
    final userModel = await flutterSecureStorage.read(key: authenticationKey);

    if (userModel == null) {
      throw UnauthorizedRequestException();
    }

    final userModelJson = json.decode(userModel);
    final token = userModelJson['token'];
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/user/home'),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        await homeLocalDatasource.saveData(response.body);
        final data = json.decode(response.body)['data'];
        return HomeModel.fromJson(data);
      } else if (response.statusCode == 401 || response.statusCode == 400) {
        throw AuthenticationException(
            errorMessage: 'Expired or invalid token used');
      } else {
        throw ServerException();
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DailyStreakModel> fetchDailyStreak(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final userModel = await flutterSecureStorage.read(key: authenticationKey);

      if (userModel == null) {
        throw UnauthorizedRequestException();
      }

      final userModelJson = json.decode(userModel);
      final token = userModelJson['token'];

      final response = await client.get(
        Uri.parse(
            '$baseUrl/user/userStreak?startDate=${DateFormat('yyyy-MM-dd').format(startDate)}&endDate=${DateFormat('yyyy-MM-dd').format(endDate)}'),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        await homeLocalDatasource.cacheDailyStreak(response.body, startDate, endDate);
        final data = json.decode(response.body)['data'];
        return DailyStreakModel.fromJson(data);
      } else if (response.statusCode == 401 || response.statusCode == 400) {
        throw AuthenticationException(
            errorMessage: 'Expired or invalid token used');
      }
      throw ServerException();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DailyQuizModel> fetchDailyQuiz() async {
    try {
      final userModel = await flutterSecureStorage.read(key: authenticationKey);

      if (userModel == null) {
        throw UnauthorizedRequestException();
      }

      final userModelJson = json.decode(userModel);
      final token = userModelJson['token'];

      final response = await client.get(
        Uri.parse('$baseUrl/dailyQuiz/getDailyQuiz'),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        await homeLocalDatasource.cacheDailyQuiz(response.body);
        final data = json.decode(response.body)['data'];
        return DailyQuizModel.fromJson(data);
      } else if (response.statusCode == 401 || response.statusCode == 400) {
        throw AuthenticationException(
            errorMessage: 'Expired or invalid token used');
      }
      throw ServerException();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DailyQuizModel> fetchDailyQuizForAnalysis(String id) async {
    try {
      final userModel = await flutterSecureStorage.read(key: authenticationKey);

      if (userModel == null) {
        throw UnauthorizedRequestException();
      }

      final userModelJson = json.decode(userModel);
      final token = userModelJson['token'];

      final response = await client.get(
        Uri.parse('$baseUrl/dailyQuiz/getDailyQuizAnalysis/$id'),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        return DailyQuizModel.fromAnalysisJson(data);
      } else if (response.statusCode == 401 || response.statusCode == 400) {
        throw AuthenticationException(
            errorMessage: 'Expired or invalid token used');
      }
      throw ServerException();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> submitDailyQuizAnswer(DailyQuizAnswer dailyQuizAnswer) async {
    try {
      final userModel = await flutterSecureStorage.read(key: authenticationKey);

      if (userModel == null) {
        throw UnauthorizedRequestException();
      }

      final userModelJson = json.decode(userModel);
      final token = userModelJson['token'];

      final payload = json.encode({
        'dailyQuizId': dailyQuizAnswer.dailyQuizId,
        'userAnswer': dailyQuizAnswer.userAnswer
            .map((userAnswer) => {
                  'questionId': userAnswer.questionId,
                  'userAnswer': userAnswer.userAnswer
                          .substring(0, userAnswer.userAnswer.length - 1) +
                      userAnswer.userAnswer
                          .substring(userAnswer.userAnswer.length - 1)
                          .toUpperCase(),
                })
            .toList(),
      });

      final response = await client.post(
        Uri.parse('$baseUrl/dailyQuiz/submitDailyQuizAnswers'),
        body: payload,
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return;
      } else if (response.statusCode == 401 || response.statusCode == 400) {
        throw AuthenticationException(
            errorMessage: 'Expired or invalid token used');
      }
      throw ServerException();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<DailyQuestModel>> fetchDailyQuest() async {
    try {
      final userModel = await flutterSecureStorage.read(key: authenticationKey);

      if (userModel == null) {
        throw UnauthorizedRequestException();
      }

      final userModelJson = json.decode(userModel);
      final token = userModelJson['token'];

      final response = await client.get(
        Uri.parse('$baseUrl/dailyQuest/getDailyQuest'),
        headers: {
          'Content-Type': 'application/json',
          'authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        await homeLocalDatasource.cacheDailyQuest(response.body);
        final data = json.decode(response.body)['data']['dailyQuest'];
        return data
            .map<DailyQuestModel>(
                (dailyQuest) => DailyQuestModel.fromJson(dailyQuest))
            .toList();
      } else if (response.statusCode == 401 || response.statusCode == 400) {
        throw AuthenticationException(
            errorMessage: 'Expired or invalid token used');
      }
      throw ServerException();
    } catch (e) {
      rethrow;
    }
  }
}
