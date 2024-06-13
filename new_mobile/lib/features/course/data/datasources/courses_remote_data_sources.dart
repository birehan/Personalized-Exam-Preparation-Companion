import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:prep_genie/features/course/data/datasources/courses_local_data_sources.dart';

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
    bool isContest,
    String contentId,
    String userQuestion,
    List<ChatHistory> chatHistory,
  );
  Future<List<ChapterVideoModel>> fetchCourseVideos(String courseId);
  Future<bool> updateVideStatus(String videoId, bool isCompleted);
  Future<void> downloadCourseById(String courseId);
}

class CourseRemoteDataSourceImpl implements CourseRemoteDataSource {
  final http.Client client;
  final CoursesLocalDatasource coursesLocalDatasource;

  final FlutterSecureStorage flutterSecureStorage;

  CourseRemoteDataSourceImpl({
    required this.coursesLocalDatasource,
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
      if (response.statusCode == 200) {
        await coursesLocalDatasource.saveUserCourses(response.body);
        var data = json.decode(response.body)['data'];
        List<dynamic> fetchedUserCourses = data['userCourses'];
        List<UserCourseModel> userCourses = fetchedUserCourses
            .map((userCourse) => UserCourseModel.fromJson(userCourse))
            .toList();

        return userCourses;
      } else if (response.statusCode == 400 || response.statusCode == 401) {
        throw AuthenticationException(errorMessage: 'Expired or Invalid token');
      } else if (response.statusCode == 429) {
        throw RequestOverloadException(errorMessage: 'Too Many Request');
      } else {
        throw ServerException();
      }
    } catch (e) {
      rethrow;
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
        await coursesLocalDatasource.saveCourseById(
          id: id,
          userCourseAnalysisJson: response.body,
        );

        final jsonData = json.decode(response.body)['data'];

        final UserCourseAnalysis course =
            UserCourseAnalysisModel.fromJson(jsonData);
        return course;
      } else if (response.statusCode == 400 || response.statusCode == 401) {
        throw AuthenticationException(errorMessage: 'Expired or Invalid token');
      } else if (response.statusCode == 429) {
        throw RequestOverloadException(errorMessage: 'Too Many Request');
      } else {
        throw ServerException();
      }
    } catch (e) {
      rethrow;
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
      } else if (response.statusCode == 429) {
        throw RequestOverloadException(errorMessage: 'Too Many Request');
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
      } else if (response.statusCode == 429) {
        throw RequestOverloadException(errorMessage: 'Too Many Request');
      } else {
        throw ServerException();
      }
    } catch (e) {
      if (e is RequestOverloadException) {
        throw RequestOverloadException(errorMessage: 'Too Many Request');
      } else {
        throw ServerException();
      }
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
      } else if (response.statusCode == 429) {
        throw RequestOverloadException(errorMessage: 'Too Many Request');
      }
      throw ServerException();
    } catch (e) {
      if (e is RequestOverloadException) {
        throw RequestOverloadException(errorMessage: 'Too Many Request');
      } else {
        throw ServerException();
      }
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
      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data']['departmentCourses'];

        return DepartmentCourseModel.fromJson(data);
      } else if (response.statusCode == 429) {
        throw RequestOverloadException(errorMessage: 'Too Many Request');
      } else {
        throw ServerException();
      }
    } catch (e) {
      if (e is RequestOverloadException) {
        throw RequestOverloadException(errorMessage: 'Too Many Request');
      } else {
        throw ServerException();
      }
    }
  }

  @override
  Future<ChatResponseModel> chat(
    bool isContest,
    String contentId,
    String userQuestion,
    List<ChatHistory> chatHistory,
  ) async {
    final userModel = await flutterSecureStorage.read(key: authenticationKey);

    if (userModel == null) {
      throw UnauthorizedRequestException();
    }

    final userModelJson = json.decode(userModel);
    final token = userModelJson['token'];

    final payload = json.encode({
      'isContest': isContest,
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
        'authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body)['data'];
      return ChatResponseModel.fromJson(data);
    } else if (response.statusCode == 429) {
      throw RequestOverloadException(errorMessage: 'Too Many Request');
    }
    throw ServerException();
  }

  @override
  Future<List<ChapterVideoModel>> fetchCourseVideos(String courseId) async {
    try {
      final userModel = await flutterSecureStorage.read(key: authenticationKey);

      if (userModel == null) {
        throw UnauthorizedRequestException();
      }

      final userModelJson = json.decode(userModel);
      final token = userModelJson['token'];
      final response = await client.get(
        Uri.parse('$baseUrl/course/video/content/$courseId'),
        headers: {
          'content-Type': 'application/json',
          'authorization': 'Bearer $token'
        },
      );
      if (response.statusCode == 200) {
        await coursesLocalDatasource.cacheCourseVideos(courseId, response.body);
        var data = json.decode(response.body)['data'];

        return (data ?? [])
            .map<ChapterVideoModel>(
              (chapterVideo) => ChapterVideoModel.fromJson(chapterVideo),
            )
            .toList();
      } else if (response.statusCode == 429) {
        throw RequestOverloadException(errorMessage: 'Too Many Request');
      } else {
        throw ServerException();
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> updateVideStatus(String videoId, bool isCompleted) async {
    final userModel = await flutterSecureStorage.read(key: authenticationKey);

    if (userModel == null) {
      throw UnauthorizedRequestException();
    }

    final userModelJson = json.decode(userModel);
    final token = userModelJson['token'];

    final payload = json.encode({
      'completed': isCompleted,
    });

    final response = await client.put(
      Uri.parse('$baseUrl/course/video/analysis/$videoId'),
      body: payload,
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 429) {
      throw RequestOverloadException(errorMessage: 'Too Many Request');
    }
    throw ServerException();
  }

  @override
  Future<void> downloadCourseById(String courseId) async {
    try {
      final userModel = await flutterSecureStorage.read(key: authenticationKey);

      if (userModel == null) {
        throw UnauthorizedRequestException();
      }

      final userModelJson = json.decode(userModel);
      final token = userModelJson['token'];
      final response = await client.get(
        Uri.parse('$baseUrl/course/download/$courseId'),
        headers: {
          'content-Type': 'application/json',
          'authorization': 'Bearer $token'
        },
      );
      if (response.statusCode == 200) {
        await coursesLocalDatasource.cacheDownloadedCourses(response.body);
      } else if (response.statusCode == 429) {
        throw RequestOverloadException(errorMessage: 'Too Many Request');
      } else {
        throw ServerException();
      }
    } catch (e) {
      rethrow;
    }
  }
}
