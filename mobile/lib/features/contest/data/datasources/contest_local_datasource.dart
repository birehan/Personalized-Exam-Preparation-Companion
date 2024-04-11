import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

abstract class ContestLocalDatasource {
  Future<void> cachePreviousContests(dynamic contests);
  Future<List<ContestModel>?> getPreviousContests();
  Future<void> cachePreviousUserContests(dynamic contests);
  Future<List<ContestModel>?> getPreviousUserContests();
  Future<void> cacheContestDetail(String id, dynamic contestDetail);
  Future<ContestDetailModel?> getContestDetail(String id);
}

class ContestLocalDatasourceImpl extends ContestLocalDatasource {
  final _contestBox = Hive.box(contestBox);

  @override
  Future<void> cachePreviousContests(dynamic contests) async {
    await _contestBox.put('previousContest', contests);
  }

  @override
  Future<void> cachePreviousUserContests(dynamic contests) async {
    await _contestBox.put('previousUserContest', contests);
  }

  @override
  Future<void> cacheContestDetail(id, contestDetail) async {
    await _contestBox.put('contest-$id', contestDetail);
  }

  @override
  Future<List<ContestModel>?> getPreviousContests() async {
    try {
      final rawData = await _contestBox.get('previousContest');
      if (rawData != null) {
        final data = json.decode(rawData)['data']['contests'];
        return data
            .map<ContestModel>(
              (contest) => ContestModel.fromJson(contest),
            )
            .toList();
      }
      return null;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<List<ContestModel>?> getPreviousUserContests() async {
    try {
      final rawData = await _contestBox.get('previousUserContest');
      if (rawData != null) {
        final data = json.decode(rawData)['data']['contests'];
        return data
            .map<ContestModel>(
              (contest) => ContestModel.fromJson(contest),
            )
            .toList();
      }
      return null;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<ContestDetailModel?> getContestDetail(String id) async {
    try {
      final rawData = await _contestBox.get('contest-$id');
      if (rawData != null) {
        final data = json.decode(rawData)['data'];
        return ContestDetailModel.fromJson(data);
      }
      return null;
    } catch (e) {
      throw CacheException();
    }
  }
}
 