import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/app_keys.dart';
import '../../../../core/core.dart';
import '../../../features.dart';

abstract class SearchCourseRemoteDataSource {
  Future<List<Course>> searchCourses(String query);
}

class SearchCourseRemoteDataSourceImpl implements SearchCourseRemoteDataSource {
  final http.Client client;

  final FlutterSecureStorage flutterSecureStorage;
  SearchCourseRemoteDataSourceImpl({
    required this.client,
    required this.flutterSecureStorage,
  });

  @override
  Future<List<Course>> searchCourses(String query) async {
    final userModel = await flutterSecureStorage.read(key: authenticationKey);

    if (userModel == null) {
      throw UnauthorizedRequestException();
    }

    final userModelJson = json.decode(userModel);
    final token = userModelJson['token'];

    try {
      final response = await client.get(
        Uri.parse('$baseUrl/course?name=$query'),
        headers: {
          'content-Type': 'application/json',
          'authorization': 'Bearer $token'
        },
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body)['data'];
        List<dynamic> fetchedCourseResult = jsonData['courses'];
        List<CourseModel> courseResults = fetchedCourseResult
            .map((course) => CourseModel.fromJson(course))
            .toList();
        return courseResults;
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
}
