import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../../../core/constants/app_keys.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

abstract class HomeRemoteDatasource {
  Future<List<UserCourse>> getMyCourses();
  Future<List<ExamDateModel>> getExamDate();
  Future<HomeModel> getHomeContent();
}

class HomeRemoteDatasourceImpl implements HomeRemoteDatasource {
  final http.Client client;
  final FlutterSecureStorage flutterSecureStorage;

  HomeRemoteDatasourceImpl({
    required this.client,
    required this.flutterSecureStorage,
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

    final response = await client.get(
      Uri.parse('$baseUrl/user/home'),
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return HomeModel.fromJson(data);
    }
    throw ServerException();
  }
}
