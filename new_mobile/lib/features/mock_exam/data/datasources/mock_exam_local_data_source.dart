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
  Future<void> cacheDownloadedMock(dynamic mock);
  Future<List<DownloadedUserMockModel>> fetchDownloadedMocks();
  Future<void> markMockAsDownloaded(String mockId);
  Future<bool> isMockDownloaded(String mockId);
  Future<void> upsertUserMockScore(String mockId, int score, bool isCompleted);
  Future<void> upsertUserMockAnswer(
      String mockId, List<QuestionUserAnswer> userAnswers);
}

class MockExamLocalDatasourceImpl extends MockExamLocalDatasource {
  final Box<dynamic> _mockBox = Hive.box(mockBox);
  final Box<dynamic> _examsBox = Hive.box(examsbox);
  final _offlineMocksBox = Hive.box(offlineMocksBox);
  final _downloadedMocksBox = Hive.box(downloadedMocksBox);

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

  @override
  Future<void> cacheDownloadedMock(mock) async {
    try {
      var mockJson = json.decode(mock);
      mockJson['data']['mock']['score'] = 0;
      mockJson['data']['mock']['isCompleted'] = false;
      var mockJsonEncoded = json.encode(mockJson);
      await _offlineMocksBox.add(mockJsonEncoded);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<List<DownloadedUserMockModel>> fetchDownloadedMocks() async {
    try {
      final mocks = _offlineMocksBox.values.toList();
      var res = <DownloadedUserMockModel>[];
      for (var mock in mocks) {
        var data = json.decode(mock)['data']['mock'];
        res.add(DownloadedUserMockModel.fromJson(data));
      }  
      return res;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<bool> isMockDownloaded(String mockId) async {
    try {
      var downloadedMocks =
          _downloadedMocksBox.get('downloadedMockId', defaultValue: <String>{});
      return downloadedMocks.contains(mockId);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> markMockAsDownloaded(String mockId) async {
    try {
      var downloadedMocks =
          _downloadedMocksBox.get('downloadedMockId', defaultValue: <String>{});
      downloadedMocks.add(mockId);
      await _downloadedMocksBox.put('downloadedMockId', downloadedMocks);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> upsertUserMockAnswer(
      String mockId, List<QuestionUserAnswer> userAnswers) async {
    try {
      final mocks = _offlineMocksBox.values.toList();
      for (int i = 0; i < mocks.length; i++) {
        var mock = mocks[i];
        var data = json.decode(mock);
        if (data['data']['mock']['_id'] == mockId) {
          for (int idx = 0; idx < userAnswers.length; idx++) {
            if (data['data']['mock']['questions'][idx]['_id'] ==
                userAnswers[idx].questionId) {
              data['data']['mock']['questions'][idx]['userAnswer'] =
                  userAnswers[idx].userAnswer;
            }
          }
          var updatedMockJson = json.encode(data);
          await _offlineMocksBox.putAt(i, updatedMockJson);
          return;
        }
      }
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> upsertUserMockScore(
      String mockId, int score, bool isCompleted) async {
    try {
      final mocks = _offlineMocksBox.values.toList();
      for (int i = 0; i < mocks.length; i++) {
        var mock = mocks[i];
        var data = json.decode(mock);
        if (data['data']['mock']['_id'] == mockId) {
          data['data']['mock']['score'] = score;
          data['data']['mock']['isCompleted'] = isCompleted;
          var updatedMockJson = json.encode(data);
          await _offlineMocksBox.putAt(i, updatedMockJson);
          return;
        }
      }
    } catch (e) {
      throw CacheException();
    }
  }
}
