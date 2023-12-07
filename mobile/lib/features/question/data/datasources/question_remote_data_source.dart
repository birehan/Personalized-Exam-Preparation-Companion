import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/app_keys.dart';
import '../../../../core/core.dart';
import '../../../features.dart';

abstract class QuestionRemoteDatasource {
  Future<void> submitUserAnswer(
    List<QuestionUserAnswer> questionUserAnswers,
  );
  Future<List<EEndQuestionsAndAnswerModel>> getEndofSubtopicQuestions(
      String subtopicId);
  Future<List<EEndQuestionsAndAnswerModel>> getEndofChapterQuestions(
      String chapterId);
  Future<ChatResponseModel> chat(
      String questionId, String userQuestion, List<ChatHistory> chatHistory);
}

class QuestionRemoteDatasourceImpl extends QuestionRemoteDatasource {
  final http.Client client;
  final FlutterSecureStorage flutterSecureStorage;

  QuestionRemoteDatasourceImpl({
    required this.client,
    required this.flutterSecureStorage,
  });

  @override
  Future<void> submitUserAnswer(
      List<QuestionUserAnswer> questionUserAnswers) async {
    final userCredential =
        await flutterSecureStorage.read(key: authenticationKey);
    if (userCredential == null) {
      throw UnauthorizedRequestException();
    }

    final userCredentialJson = json.decode(userCredential);
    final token = userCredentialJson['token'];

    final payload = json.encode(
      {
        "questionUserAnswers": questionUserAnswers
            .map(
              (questionUserAnswer) => {
                'questionId': questionUserAnswer.questionId,
                'userAnswer': questionUserAnswer.userAnswer.substring(
                        0, questionUserAnswer.userAnswer.length - 1) +
                    questionUserAnswer.userAnswer
                        .substring(questionUserAnswer.userAnswer.length - 1)
                        .toUpperCase(),
              },
            )
            .toList(),
      },
    );
    final response = await client.post(
      Uri.parse('$baseUrl/questionUserAnswer/upsertUserAnswers'),
      body: payload,
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 201) {
      return;
    }
    throw ServerException();
  }

  @override
  Future<List<EEndQuestionsAndAnswerModel>> getEndofSubtopicQuestions(
      String subtopicId) async {
    final userModel = await flutterSecureStorage.read(key: authenticationKey);

    if (userModel == null) {
      throw UnauthorizedRequestException();
    }

    final userModelJson = json.decode(userModel);
    final token = userModelJson['token'];
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/sub-chapter/endOfSubQuestions/$subtopicId'),
        headers: {
          'content-Type': 'application/json',
          'authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data'];
        List<dynamic> fetchedQuestions = data['questions'];

        List<EEndQuestionsAndAnswerModel> questionUserAnswer =
            fetchedQuestions.map((questiondata) {
          return EEndQuestionsAndAnswerModel(
            question: QuestionModel.fromJson(questiondata['question']),
            userAnswer: UserAnswerModel.fromJson(questiondata['userAnswer']),
          );
        }).toList();

        return questionUserAnswer;
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<ChatResponseModel> chat(
    String questionId,
    String userQuestion,
    List<ChatHistory> chatHistory,
  ) async {
    final payload = json.encode({
      'questionId': questionId,
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
      Uri.parse('$baseUrl/chat/onQuestion'),
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

  @override
  Future<List<EEndQuestionsAndAnswerModel>> getEndofChapterQuestions(
      String chapterId) async {
    final userModel = await flutterSecureStorage.read(key: authenticationKey);

    if (userModel == null) {
      throw UnauthorizedRequestException();
    }

    final userModelJson = json.decode(userModel);
    final token = userModelJson['token'];
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/chapter/endOfChapterQuestions/$chapterId'),
        headers: {
          'content-Type': 'application/json',
          'authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data'];
        List<dynamic> fetchedQuestions = data['questions'];

        List<EEndQuestionsAndAnswerModel> questions =
            fetchedQuestions.map((questiondata) {
          return EEndQuestionsAndAnswerModel(
              question: QuestionModel.fromJson(questiondata['question']),
              userAnswer: UserAnswerModel.fromJson(questiondata['userAnswer']));
        }).toList();

        return questions;
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}
