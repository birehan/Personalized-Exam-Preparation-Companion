import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/app_enums.dart';
import '../../../../core/constants/app_keys.dart';
import '../../../../core/error/exception.dart';
import '../../domain/entities/feedback_entity.dart';

abstract class FeedbackRemoteDataSource {
  Future<void> submitFeedbackResponse(FeedbackEntity feedback);
  Future<void> voteQuestion(String questionId);
  Future<void> removeQuestionVote(String questionId);
}

class FeedbackRemoteDataSourceImpl implements FeedbackRemoteDataSource {
  final http.Client client;

  final FlutterSecureStorage flutterSecureStorage;

  FeedbackRemoteDataSourceImpl({
    required this.client,
    required this.flutterSecureStorage,
  });
  @override
  Future<void> submitFeedbackResponse(FeedbackEntity feedback) async {
    final userModel = await flutterSecureStorage.read(key: authenticationKey);

    if (userModel == null) {
      throw UnauthorizedRequestException();
    }

    final userModelJson = json.decode(userModel);
    final token = userModelJson['token'];

    try {
      late Map<String, dynamic> feedbackPaylod;
      late String flagEndpoint = '';

      if (feedback.feedbackType == FeedbackType.questionFeedback) {
        flagEndpoint = 'questionFlag';
        feedbackPaylod = {
          'questionId': feedback.id,
          'comment': feedback.message
        };
      } else {
        flagEndpoint = 'contentFlag';
        feedbackPaylod = {
          'subChapterContentId': feedback.id,
          'comment': feedback.message
        };
      }

      final response = await client.post(
        Uri.parse('$baseUrl/$flagEndpoint'),
        headers: {
          'content-Type': 'application/json',
          'authorization': 'Bearer $token'
        },
        body: json.encode(feedbackPaylod),
      );
      if (response.statusCode != 201) {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> voteQuestion(String questionId) async {
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
      if (response.statusCode != 201) {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> removeQuestionVote(String questionId) async {
    final userModel = await flutterSecureStorage.read(key: authenticationKey);

    if (userModel == null) {
      throw UnauthorizedRequestException();
    }

    final userModelJson = json.decode(userModel);
    final token = userModelJson['token'];
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/userQuestionVote/$questionId'),
        headers: {
          'content-Type': 'application/json',
          'authorization': 'Bearer $token'
        },
      );
      if (response.statusCode != 200) {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}
