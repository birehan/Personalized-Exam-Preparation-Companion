import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

abstract class MockExamLocalDatasource {
  Future<List<DepartmentMockModel>?> getDepartmentMocks({
    required String id,
    required bool isStandard,
  });
  Future<void> cacheDepartmentMocks({
    required dynamic departmentMocks,
    required String id,
    required bool isStandard,
  });
  Future<List<UserMockModel>?> getMyMocks();
  Future<void> cacheMyMocks(dynamic myMocks);
  Future<MockModel?> getCachedMockExam(
      {required String id, required int pageNumer});
  Future<void> saveMockExam(
      {required dynamic mockExam, required String id, required int pageNumer});
}

class MockExamLocalDatasourceImpl extends MockExamLocalDatasource {
  final Box<dynamic> _mockBox = Hive.box(mockBox);
  final Box<dynamic> _examsBox = Hive.box(examsbox);

  @override
  Future<void> cacheDepartmentMocks({
    required dynamic departmentMocks,
    required String id,
    required bool isStandard,
  }) async {
    await _mockBox.put('departmentMocks-$id-$isStandard', departmentMocks);
  }

  @override
  Future<void> cacheMyMocks(dynamic myMocks) async {
    await _mockBox.put('myMocks', myMocks);
  }

  @override
  Future<List<DepartmentMockModel>?> getDepartmentMocks({
    required String id,
    required bool isStandard,
  }) async {
    try {
      final rawData = await _mockBox.get('departmentMocks-$id-$isStandard');
      if (rawData != null) {
        final data = json.decode(rawData)['data']['departmentMocks'];
        final departmentMocks = data
            .map<DepartmentMockModel>(
              (departmentMock) => DepartmentMockModel.fromJson(departmentMock),
            )
            .toList();
        return departmentMocks;
      }
      return null;
    } catch (e) {
      print(e.toString());
      throw CacheException();
    }
  }

  @override
  Future<List<UserMockModel>?> getMyMocks() async {
    try {
      final rawData = await _mockBox.get('myMocks');
      if (rawData != null) {
        final data = json.decode(rawData)['data']['allUserMocks'];
        final myMocks = data
            .map<UserMockModel>(
              (myMock) => UserMockModel.fromJson(myMock),
            )
            .toList();
        return myMocks;
      }
      return null;
    } catch (e) {
      print(e.toString());
      throw CacheException();
    }
  }

  @override
  Future<MockModel?> getCachedMockExam(
      {required String id, required int pageNumer}) async {
    try {
      final mockExam = await _examsBox.get('$id-$pageNumer');
      if (mockExam != null) {
        final data = json.decode(mockExam)['data'];
        return MockModel.fromJson(data);
      }
      return null;
    } catch (e) {
      print(e.toString());
      throw CacheException();
    }
  }

  @override
  Future<void> saveMockExam(
      {required dynamic mockExam,
      required String id,
      required int pageNumer}) async {
    try {
      await _examsBox.put('$id-$pageNumer', mockExam);
    } catch (e) {
      print(e.toString());
      throw CacheException();
    }
  }
}
