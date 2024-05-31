import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:skill_bridge_mobile/features/question/domain/entities/general_chat_entity.dart';

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
  Future<ChatResponseModel> chat(String questionId, String userQuestion,
      List<ChatHistory> chatHistory, bool isContest);

  Future<ChatResponseModel> sendGeneralChat(
      {required GeneralChatEntity generalChat});
  Future<Question> getQuestionById({required String questionId});
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
    } else if (response.statusCode == 429) {
      throw RequestOverloadException(errorMessage: 'Too Many Request');
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
  Future<ChatResponseModel> chat(
    String questionId,
    String userQuestion,
    List<ChatHistory> chatHistory,
    bool isContest,
  ) async {
    final userModel = await flutterSecureStorage.read(key: authenticationKey);

    if (userModel == null) {
      throw UnauthorizedRequestException();
    }

    final userModelJson = json.decode(userModel);
    final token = userModelJson['token'];
    final payload = json.encode({
      'isContest': isContest,
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
  Future<ChatResponseModel> sendGeneralChat(
      {required GeneralChatEntity generalChat}) async {
    final userModel = await flutterSecureStorage.read(key: authenticationKey);

    if (userModel == null) {
      throw UnauthorizedRequestException();
    }

    final userModelJson = json.decode(userModel);
    final token = userModelJson['token'];
    final payload = json.encode({
      'userQuestion': generalChat.userQuestion,
      'chatHistoryObj': generalChat.chatHistory
          .map(
            (chat) => [
              chat.human,
              chat.ai,
            ],
          )
          .toList(),
    });
    final page = generalChat.pageName;
    final response = await client.post(
      Uri.parse('$baseUrl/chat/Assistant?currentPage=$page'),
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
  Future<Question> getQuestionById({required String questionId}) async {
    final userModel = await flutterSecureStorage.read(key: authenticationKey);

    if (userModel == null) {
      throw UnauthorizedRequestException();
    }

    final userModelJson = json.decode(userModel);
    final token = userModelJson['token'];
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/question/$questionId'),
        headers: {
          'content-Type': 'application/json',
          'authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body)['data'];
        Map<String, dynamic> decodedQuestion = data['question'];

        Question question = QuestionModel.fromJson(decodedQuestion);

        return question;
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}
