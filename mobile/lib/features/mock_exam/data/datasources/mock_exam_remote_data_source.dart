import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/app_keys.dart';
import '../../../../core/core.dart';
import '../../../features.dart';

abstract class MockExamRemoteDatasource {
  Future<List<MockExamModel>> getMocks();
  Future<MockModel> getMockById(String id);
  Future<MockExamModel> getMockAnalysis();
  Future<List<DepartmentMockModel>> getDepartmentMocks(String departmentId, bool isStandard);
  Future<void> upsertMockScore(String mockId, int score);
  Future<List<UserMockModel>> getMyMocks();
  Future<void> addMocktoUserMocks(String mockId);
}

class MockExamRemoteDatasourceImpl extends MockExamRemoteDatasource {
  final http.Client client;
  final FlutterSecureStorage flutterSecureStorage;

  MockExamRemoteDatasourceImpl({
    required this.client,
    required this.flutterSecureStorage,
  });

  @override
  Future<MockExamModel> getMockAnalysis() {
    // TODO: implement getMockAnalysis
    throw UnimplementedError();
  }

  @override
  Future<MockModel> getMockById(String id) async {
    final userModel = await flutterSecureStorage.read(key: authenticationKey);

    if (userModel == null) {
      throw UnauthorizedRequestException();
    }

    final userModelJson = json.decode(userModel);
    final token = userModelJson['token'];

    final response = await client.get(
      Uri.parse('$baseUrl/mock/$id'),
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return MockModel.fromJson(data);
    }
    throw ServerException();
  }

  @override
  Future<List<MockExamModel>> getMocks() async {
    final response = await client.get(
      Uri.parse('$baseUrl/mock'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data']['mocks'];
      return data
          .map<MockExamModel>(
            (mockExam) => MockExamModel.fromJson(mockExam),
          )
          .toList();
    }
    throw ServerException();
  }

  @override
  Future<List<DepartmentMockModel>> getDepartmentMocks(String departmentId, bool isStandard) async {
    final response = await client.get(
      Uri.parse('$baseUrl/mock/departmentMocks?depId=$departmentId&isStandard=$isStandard'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data']['departmentMocks'];
      return data
          .map<DepartmentMockModel>(
            (departmentMockModel) =>
                DepartmentMockModel.fromJson(departmentMockModel),
          )
          .toList();
    }
    throw ServerException();
  }

  @override
  Future<void> upsertMockScore(String mockId, int score) async {
    final userCredential =
        await flutterSecureStorage.read(key: authenticationKey);
    if (userCredential == null) {
      throw UnauthorizedRequestException();
    }

    final userCredentialJson = json.decode(userCredential);
    final token = userCredentialJson['token'];

    final payload = json.encode(
      {
        'mockId': mockId,
        'score': score,
      },
    );

    final response = await client.post(
      Uri.parse('$baseUrl/userMockScore'),
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
  Future<List<UserMockModel>> getMyMocks() async {
    final userCredential =
        await flutterSecureStorage.read(key: authenticationKey);
    if (userCredential == null) {
      throw UnauthorizedRequestException();
    }

    final userCredentialJson = json.decode(userCredential);
    final token = userCredentialJson['token'];

    final response = await client.get(
      Uri.parse('$baseUrl/userMock'),
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data']['allUserMocks'];
      return data
          .map<UserMockModel>(
            (mock) => UserMockModel.fromJson(mock),
          )
          .toList();
    }
    throw ServerException();
  }

  @override
  Future<void> addMocktoUserMocks(String mockId) async {
    final userCredential =
        await flutterSecureStorage.read(key: authenticationKey);
    if (userCredential == null) {
      throw UnauthorizedRequestException();
    }

    final userCredentialJson = json.decode(userCredential);
    final token = userCredentialJson['token'];

    final payload = json.encode(
      {'mock': mockId},
    );

    final response = await client.put(
      Uri.parse('$baseUrl/userMock/addMock'),
      body: payload,
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return;
    }
    throw ServerException();
  }
}
