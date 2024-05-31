import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:skill_bridge_mobile/core/constants/app_keys.dart';
import 'package:skill_bridge_mobile/core/core.dart';

import '../../../features.dart';

abstract class ContestRemoteDatasource {
  Future<List<ContestModel>> fetchPreviousContests();
  Future<ContestModel> fetchContestById({
    required String contestId,
  });
  Future<List<ContestModel>> fetchPreviousUserContests();
  Future<ContestModel?> fetchUpcomingUserContest();
  Future<ContestModel> registerToContest(String contestId);
  Future<ContestDetail> getContestDetail(String contestId);
  Future<List<ContestQuestionModel>> fetchContestQuestionByCategory({
    required String categoryId,
  });
  Future<void> submitUserContestAnswer(ContestUserAnswer contestUserAnswer);
  Future<ContestRankModel> getContestRanking(String contestId);
  Future<List<ContestQuestionModel>> fetchContestAnalysisByCategory({
    required String categoryId,
  });
}

class ContestRemoteDatasourceImpl extends ContestRemoteDatasource {
  ContestRemoteDatasourceImpl({
    required this.client,
    required this.flutterSecureStorage,
    required this.contestLocalDatasource,
  });

  final http.Client client;
  final FlutterSecureStorage flutterSecureStorage;
  final ContestLocalDatasource contestLocalDatasource;

  @override
  Future<List<ContestModel>> fetchPreviousContests() async {
    final userCredentialString =
        await flutterSecureStorage.read(key: authenticationKey);

    if (userCredentialString == null) {
      throw UnauthorizedRequestException();
    }

    final userCredentialJson = json.decode(userCredentialString);
    final token = userCredentialJson['token'];

    try {
      final response = await client.get(
        Uri.parse('$baseUrl/contest/previousContests'),
        headers: {
          'content-type': 'application/json',
          'authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        await contestLocalDatasource.cachePreviousContests(response.body);
        final data = json.decode(response.body)['data']['contests'];
        if (data == null) {
          return [];
        }
        return data
            .map<ContestModel>(
              (contest) => ContestModel.fromJson(contest),
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
  Future<ContestModel> fetchContestById({required String contestId}) async {
    final userCredentialString =
        await flutterSecureStorage.read(key: authenticationKey);

    if (userCredentialString == null) {
      throw UnauthorizedRequestException();
    }

    final userCredentialJson = json.decode(userCredentialString);
    final token = userCredentialJson['token'];

    try {
      final response = await client.get(
        Uri.parse('$baseUrl/contest/$contestId'),
        headers: {
          'content-type': 'application/json',
          'authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data']['contest'];
        return ContestModel.fromJson(data);
      } else if (response.statusCode == 429) {
        throw RequestOverloadException(errorMessage: 'Too Many Request');
      }  else {
        throw ServerException();
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ContestModel>> fetchPreviousUserContests() async {
    final userCredentialString =
        await flutterSecureStorage.read(key: authenticationKey);

    if (userCredentialString == null) {
      throw UnauthorizedRequestException();
    }

    final userCredentialJson = json.decode(userCredentialString);
    final token = userCredentialJson['token'];

    try {
      final response = await client.get(
        Uri.parse('$baseUrl/contest/userContest/userPreviousContests'),
        headers: {
          'content-type': 'application/json',
          'authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        await contestLocalDatasource.cachePreviousUserContests(response.body);
        final data = json.decode(response.body)['data']['contests'];
        return data
            .map<ContestModel>(
              (contest) => ContestModel.fromJson(contest),
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
  Future<ContestModel?> fetchUpcomingUserContest() async {
    final userCredentialString =
        await flutterSecureStorage.read(key: authenticationKey);

    if (userCredentialString == null) {
      throw UnauthorizedRequestException();
    }

    final userCredentialJson = json.decode(userCredentialString);
    final token = userCredentialJson['token'];

    try {
      final response = await client.get(
        Uri.parse('$baseUrl/contest/userContest/upcomingContest'),
        headers: {
          'content-type': 'application/json',
          'authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data']['contest'];
        if (data == null) {
          return null;
        }
        return ContestModel.fromJson(data);
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
  Future<ContestModel> registerToContest(String contestId) async {
    final userCredentialString =
        await flutterSecureStorage.read(key: authenticationKey);

    if (userCredentialString == null) {
      throw UnauthorizedRequestException();
    }

    final userCredentialJson = json.decode(userCredentialString);
    final token = userCredentialJson['token'];
    try {
      Map<String, dynamic> contestIdPayload = {'contestId': contestId};

      final response = await client.post(
        Uri.parse('$baseUrl/contest/userContest'),
        headers: {
          'content-type': 'application/json',
          'authorization': 'Bearer $token',
        },
        body: json.encode(contestIdPayload),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body)['data']['newUserContest'];
        return ContestModel.fromJson(data);
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
  Future<ContestDetail> getContestDetail(String contestId) async {
    final userCredentialString =
        await flutterSecureStorage.read(key: authenticationKey);

    if (userCredentialString == null) {
      throw UnauthorizedRequestException();
    }

    final userCredentialJson = json.decode(userCredentialString);
    final token = userCredentialJson['token'];
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/contest/contestDetail/$contestId'),
        headers: {
          'content-type': 'application/json',
          'authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        await contestLocalDatasource.cacheContestDetail(
            contestId, response.body);
        final res = json.decode(response.body);
        Map<String, dynamic> data = res['data'];
        return ContestDetailModel.fromJson(data);
      } else if (response.statusCode == 429) {
        throw RequestOverloadException(errorMessage: 'Too Many Request');
      } else {
        print(response.body);
        throw ServerException();
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ContestRankModel> getContestRanking(String contestId) async {
    final userCredentialString =
        await flutterSecureStorage.read(key: authenticationKey);

    if (userCredentialString == null) {
      throw UnauthorizedRequestException();
    }

    final userCredentialJson = json.decode(userCredentialString);
    final token = userCredentialJson['token'];
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/contest/contestRank/$contestId'),
        headers: {
          'content-type': 'application/json',
          'authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final res = json.decode(response.body);
        Map<String, dynamic> data = res['data'];
        return ContestRankModel.fromJson(data);
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
  Future<List<ContestQuestionModel>> fetchContestQuestionByCategory({
    required String categoryId,
  }) async {
    final userCredentialString =
        await flutterSecureStorage.read(key: authenticationKey);

    if (userCredentialString == null) {
      throw UnauthorizedRequestException();
    }

    final userCredentialJson = json.decode(userCredentialString);
    final token = userCredentialJson['token'];
    try {
      final response = await client.get(
        Uri.parse(
            '$baseUrl/contest/contestCategory/categoryQuestions/$categoryId'),
        headers: {
          'content-type': 'application/json',
          'authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data']['questions'];
        return data
            .map<ContestQuestionModel>(
              (contestQuestion) =>
                  ContestQuestionModel.fromJson(contestQuestion),
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
  Future<void> submitUserContestAnswer(
      ContestUserAnswer contestUserAnswer) async {
    try {
      final userCredentialString =
          await flutterSecureStorage.read(key: authenticationKey);

      if (userCredentialString == null) {
        throw UnauthorizedRequestException();
      }

      final userCredentialJson = json.decode(userCredentialString);
      final token = userCredentialJson['token'];

      final payload = json.encode(
        {
          'contestCategory': contestUserAnswer.contestCategoryId,
          'userAnswer': contestUserAnswer.userAnswers
              .map(
                (userAnswer) => {
                  'contestQuestionId': userAnswer.contestQuestionId,
                  'userAnswer': userAnswer.userAnswer
                          .substring(0, userAnswer.userAnswer.length - 1) +
                      userAnswer.userAnswer
                          .substring(userAnswer.userAnswer.length - 1)
                          .toUpperCase(),
                },
              )
              .toList(),
        },
      );

      final response = await client.post(
        Uri.parse('$baseUrl/contest/contestCategory/submitAnswer'),
        headers: {
          'content-type': 'application/json',
          'authorization': 'Bearer $token',
        },
        body: payload,
      );

      if (response.statusCode == 200) {
        return;
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
  Future<List<ContestQuestionModel>> fetchContestAnalysisByCategory({
    required String categoryId,
  }) async {
    final userCredentialString =
        await flutterSecureStorage.read(key: authenticationKey);

    if (userCredentialString == null) {
      throw UnauthorizedRequestException();
    }

    final userCredentialJson = json.decode(userCredentialString);
    final token = userCredentialJson['token'];
    try {
      final response = await client.get(
        Uri.parse(
            '$baseUrl/contest/contestCategory/categoryAnalysis/$categoryId'),
        headers: {
          'content-type': 'application/json',
          'authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data']['questions'];
        return data
            .map<ContestQuestionModel>(
              (contestQuestion) =>
                  ContestQuestionModel.fromAnalysisJson(contestQuestion),
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
}
