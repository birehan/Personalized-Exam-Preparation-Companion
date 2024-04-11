import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:prepgenie/core/constants/constants.dart';
import 'package:prepgenie/core/error/exception.dart';

import '../../../features.dart';

abstract class HomeLocalDatasource {
  // Future<List<UserCourse>> getMyCourses();
  // Future<ExamDateModel> getExamDate();
  // Future<void> cacheMyCourses(List<UserCourse> courses);
  // Future<void> cacheExamDate(ExamDate examDate);
  Future<HomeModel?> getCachedHomeState();
  Future<void> saveData(rawData);
  Future<void> cacheDailyStreak(
      dynamic dailyStreak, DateTime startDate, DateTime endDate);
  Future<DailyStreakModel?> getCachedDailyStreak(
      DateTime startDate, DateTime endDate);
  Future<void> cacheDailyQuest(dynamic dailyQuest);
  Future<List<DailyQuestModel>?> getCachedDailyQuest();
  Future<void> cacheDailyQuiz(dynamic dailyQuiz);
  Future<DailyQuizModel?> getCachedDailyQuiz();
}

class HomeLocalDatasourceImpl implements HomeLocalDatasource {
  final Box<dynamic> _homeBox = Hive.box(homeBox);

  @override
  Future<HomeModel?> getCachedHomeState() async {
    try {
      // await Hive.openBox('homeBox');
      final rawData = await _homeBox.get('homeData');
      if (rawData != null) {
        final data = json.decode(rawData)['data'];
        HomeModel home = HomeModel.fromJson(data);
        return home;
      }
      return null;
    } catch (e) {
      print(e.toString());
      throw CacheException();
    }
  }

  @override
  Future<void> saveData(dynamic rawData) async {
    // await Hive.openBox('homeBox');
    await _homeBox.put('homeData', rawData);
  }

  @override
  Future<void> cacheDailyQuest(dynamic dailyQuest) async {
    await _homeBox.put('dailyQuest', dailyQuest);
  }

  @override
  Future<void> cacheDailyStreak(
      dynamic dailyStreak, DateTime startDate, DateTime endDate) async {
    await _homeBox.put(
        'dailyStreak-${DateFormat('dd-MM-yyyy').format(startDate)}-${DateFormat('dd-MM-yyyy').format(endDate)}',
        dailyStreak);
  }

  @override
  Future<List<DailyQuestModel>?> getCachedDailyQuest() async {
    try {
      final rawData = await _homeBox.get('dailyQuest');
      if (rawData != null) {
        final data = json.decode(rawData)['data']['dailyQuest'];
        return data
            .map<DailyQuestModel>(
                (dailyQuest) => DailyQuestModel.fromJson(dailyQuest))
            .toList();
      }
      return null;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<DailyStreakModel?> getCachedDailyStreak(
      DateTime startDate, DateTime endDate) async {
    try {
      final rawData = await _homeBox.get(
          'dailyStreak-${DateFormat('dd-MM-yyyy').format(startDate)}-${DateFormat('dd-MM-yyyy').format(endDate)}');
      if (rawData != null) {
        final data = json.decode(rawData)['data'];
        return DailyStreakModel.fromJson(data);
      }
      return null;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheDailyQuiz(dailyQuiz) async {
    await _homeBox.put('dailyQuiz', dailyQuiz);
  }

  @override
  Future<DailyQuizModel?> getCachedDailyQuiz() async {
    try {
      final rawData = await _homeBox.get('dailyQuiz');
      if (rawData != null) {
        final data = json.decode(rawData)['data'];
        return DailyQuizModel.fromJson(data);
      }
      return null;
    } catch (e) {
      throw CacheException();
    }
  }
}
