import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:skill_bridge_mobile/features/bookmarks/data/data.dart';

import '../../../../core/constants/app_keys.dart';
import '../../../../core/error/exception.dart';
import '../../domain/entities/bookmarked_contents_and_questions.dart';
import 'package:http/http.dart' as http;

abstract class BookmarksRemoteDatasource {
  Future<Bookmarks> getUserBookmarks();
  Future<bool> bookmarkContent(String contentId);
  Future<void> removeContentBookmark(String contentId);
  Future<void> removeQuestionBookmark(String questinoId);
  Future<void> bookmarkQuestion(String questionId);
}

class BookmarksRemoteDatasourceImpl implements BookmarksRemoteDatasource {
  final http.Client client;

  final FlutterSecureStorage flutterSecureStorage;
  BookmarksRemoteDatasourceImpl({
    required this.client,
    required this.flutterSecureStorage,
  });
  @override
  Future<bool> bookmarkContent(String contentId) async {
    final userModel = await flutterSecureStorage.read(key: authenticationKey);

    if (userModel == null) {
      throw UnauthorizedRequestException();
    }

    final userModelJson = json.decode(userModel);
    final token = userModelJson['token'];

    try {
      Map<String, dynamic> payload = {'contentId': contentId};
      final response = await client.post(
        Uri.parse('$baseUrl/userContentBookmark'),
        headers: {
          'content-Type': 'application/json',
          'authorization': 'Bearer $token'
        },
        body: json.encode(payload),
      );

      if (response.statusCode == 201) {
        return true;
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
  Future<Bookmarks> getUserBookmarks() async {
    final userModel = await flutterSecureStorage.read(key: authenticationKey);

    if (userModel == null) {
      throw UnauthorizedRequestException();
    }

    final userModelJson = json.decode(userModel);
    final token = userModelJson['token'];

    try {
      final response = await client.get(
        Uri.parse('$baseUrl/user/bookmarks'),
        headers: {
          'content-Type': 'application/json',
          'authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 201) {
        final jsonData = json.decode(response.body)['data'];
        // CourseModel course = CourseModel.fromJson(jsonData['course']);
        Bookmarks bookmarks = BookmarksModel.fromJson(jsonData);

        return bookmarks;
      } else if (response.statusCode == 429) {
        throw RequestOverloadException(errorMessage: 'Too Many Request');
      } else {
        throw ServerException();
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  Future<void> removeContentBookmark(String contentId) async {
    final userModel = await flutterSecureStorage.read(key: authenticationKey);

    if (userModel == null) {
      throw UnauthorizedRequestException();
    }

    final userModelJson = json.decode(userModel);
    final token = userModelJson['token'];

    try {
      final response = await client.post(
        Uri.parse('$baseUrl/userContentBookmark/$contentId'),
        headers: {
          'content-Type': 'application/json',
          'authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        return;
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
  Future<void> bookmarkQuestion(String questionId) async {
    final userModel = await flutterSecureStorage.read(key: authenticationKey);

    if (userModel == null) {
      throw UnauthorizedRequestException();
    }

    final userModelJson = json.decode(userModel);
    final token = userModelJson['token'];

    try {
      Map<String, dynamic> payload = {'questionId': questionId};
      final response = await client.post(
        Uri.parse('$baseUrl/userQuestionVote'),
        headers: {
          'content-Type': 'application/json',
          'authorization': 'Bearer $token'
        },
        body: json.encode(payload),
      );

      if (response.statusCode == 201) {
        return;
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
  Future<void> removeQuestionBookmark(String questinoId) async {
    final userModel = await flutterSecureStorage.read(key: authenticationKey);

    if (userModel == null) {
      throw UnauthorizedRequestException();
    }

    final userModelJson = json.decode(userModel);
    final token = userModelJson['token'];

    try {
      final response = await client.post(
        Uri.parse('$baseUrl/userQuestionVote/$questinoId'),
        headers: {
          'content-Type': 'application/json',
          'authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        return;
      } else if (response.statusCode == 429) {
        throw RequestOverloadException(errorMessage: 'Too Many Request');
      }  else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}
