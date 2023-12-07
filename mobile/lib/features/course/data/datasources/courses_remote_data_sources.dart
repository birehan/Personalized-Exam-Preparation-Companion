import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/app_keys.dart';
import '../../../../core/core.dart';
import '../../../features.dart';
import '../models/department_course_model.dart';
import '../models/user_course_analysis_model.dart';

abstract class CourseRemoteDataSource {
  Future<List<UserCourse>> getUserCourses();
  Future<UserCourseAnalysis> getCourseById(String id);
  Future<List<Course>> getCoursesByDepartmentId(String id);
  Future<bool> registercourse(String courseId);
  Future<bool> registerSubChapter(String subChapterId, String chapterId);
  Future<DepartmentCourse> getDepartmentCourse(String id);
  Future<ChatResponseModel> chat(
    String contentId,
    String userQuestion,
    List<ChatHistory> chatHistory,
  );
}

class CourseRemoteDataSourceImpl implements CourseRemoteDataSource {
  final http.Client client;

  final FlutterSecureStorage flutterSecureStorage;
  CourseRemoteDataSourceImpl({
    required this.client,
    required this.flutterSecureStorage,
  });

  @override
  Future<List<UserCourse>> getUserCourses() async {
    final userModel = await flutterSecureStorage.read(key: authenticationKey);

    if (userModel == null) {
      throw UnauthorizedRequestException();
    }

    final userModelJson = json.decode(userModel);
    final token = userModelJson['token'];
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/userCourse'),
        headers: {
          'content-Type': 'application/json',
          'authorization': 'Bearer $token'
        },
      );
      // print('response $response ${response.statusCode} ${response.body}');
      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data'];
        List<dynamic> fetchedUserCourses = data['userCourses'];

        List<UserCourseModel> userCourses = fetchedUserCourses
            .map((userCourse) => UserCourseModel.fromJson(userCourse))
            .toList();

        return userCourses;
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<UserCourseAnalysis> getCourseById(String id) async {
    final userModel = await flutterSecureStorage.read(key: authenticationKey);

    if (userModel == null) {
      throw UnauthorizedRequestException();
    }

    final userModelJson = json.decode(userModel);
    final token = userModelJson['token'];

    try {
      final response = await client.get(
        Uri.parse('$baseUrl/course/$id'),
        headers: {
          'content-Type': 'application/json',
          'authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body)['data'];
        // CourseModel course = CourseModel.fromJson(jsonData['course']);
        final UserCourseAnalysis course =
            UserCourseAnalysisModel.fromJson(jsonData);
        return course;
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<List<Course>> getCoursesByDepartmentId(String id) async {
    final userModel = await flutterSecureStorage.read(key: authenticationKey);

    if (userModel == null) {
      throw UnauthorizedRequestException();
    }

    final userModelJson = json.decode(userModel);
    final token = userModelJson['token'];
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/course/departmentCourses/$id'),
        headers: {
          'content-Type': 'application/json',
          'authorization': 'Bearer $token'
        },
      );
      print('status , ${response.statusCode}');
      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data'];
        List<dynamic> fetchedUserCourses = data['departmentCourses'];

        List<Course> userCourses = fetchedUserCourses
            .map((course) => CourseModel.fromJson(course))
            .toList();

        return userCourses;
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<bool> registercourse(String courseId) async {
    final userModel = await flutterSecureStorage.read(key: authenticationKey);

    if (userModel == null) {
      throw UnauthorizedRequestException();
    }

    final userModelJson = json.decode(userModel);
    final token = userModelJson['token'];
    try {
      Map<String, dynamic> courseIdPaylaod = {'course': courseId};
      final response = await client.put(
        Uri.parse('$baseUrl/userCourse/addCourse'),
        headers: {
          'content-Type': 'application/json',
          'authorization': 'Bearer $token'
        },
        body: json.encode(courseIdPaylaod),
      );
      if (response.statusCode == 200) {
        return true;
      }
      throw ServerException();
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<bool> registerSubChapter(String subChapterId, String chapterId) async {
    final userModel = await flutterSecureStorage.read(key: authenticationKey);

    if (userModel == null) {
      throw UnauthorizedRequestException();
    }

    final userModelJson = json.decode(userModel);
    final token = userModelJson['token'];
    try {
      Map<String, dynamic> subChapterPayload = {
        'subChapterId': subChapterId,
        'chapterId': chapterId
      };
      final response = await client.post(
        Uri.parse('$baseUrl/userChapterAnalysis/addSubChapter'),
        headers: {
          'content-Type': 'application/json',
          'authorization': 'Bearer $token'
        },
        body: json.encode(subChapterPayload),
      );
      if (response.statusCode == 200) {
        return true;
      }
      throw ServerException();
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<DepartmentCourse> getDepartmentCourse(String id) async {
    final userModel = await flutterSecureStorage.read(key: authenticationKey);

    if (userModel == null) {
      throw UnauthorizedRequestException();
    }

    final userModelJson = json.decode(userModel);
    final token = userModelJson['token'];
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/course/departmentCourses/$id'),
        headers: {
          'content-Type': 'application/json',
          'authorization': 'Bearer $token'
        },
      );
      print('status , ${response.statusCode}');
      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data']['departmentCourses'];

        return DepartmentCourseModel.fromJson(data);
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<ChatResponseModel> chat(
    String contentId,
    String userQuestion,
    List<ChatHistory> chatHistory,
  ) async {
    final payload = json.encode({
      'contentId': contentId,
      'userQuestion': userQuestion,
      'chatHistoryObj': chatHistory
          .map(
            (chat) => [
              chat.human,
              chat.ai,
            ],
          )
          .toList(),
    });

    final response = await client.post(
      Uri.parse('$baseUrl/chat/onContent'),
      body: payload,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body)['data'];
      return ChatResponseModel.fromJson(data);
    }
    throw ServerException();
  }
}
