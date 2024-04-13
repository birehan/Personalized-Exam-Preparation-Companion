import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:prepgenie/core/constants/constants.dart';
import 'package:prepgenie/core/error/exception.dart';
import 'package:prepgenie/features/course/data/models/user_course_analysis_model.dart';

import '../../../features.dart';

abstract class CoursesLocalDatasource {
  Future<List<UserCourse>?> getCachedUserCourses();
  Future<void> saveUserCourses(dynamic userCourses);
  Future<UserCourseAnalysis?> getCachedCourseById(String id);
  Future<void> saveCourseById({
    required String id,
    required dynamic userCourseAnalysisJson,
  });
  Future<void> cacheCourseVideos(String courseId, dynamic courseVideos);
  Future<List<ChapterVideoModel>?> getCachedCourseVideos(String courseId);
}

class CoursesLocalDatasourceImpl implements CoursesLocalDatasource {
  final Box<dynamic> _courseBox = Hive.box(courseBox);

  @override
  Future<List<UserCourse>?> getCachedUserCourses() async {
    try {
      final userCoursesJson = await _courseBox.get('userCourses');
      if (userCoursesJson != null) {
        final data = json.decode(userCoursesJson)['data'];
        List<dynamic> courses = data['userCourses'];
        List<UserCourseModel> userCourses = courses
            .map((userCourse) => UserCourseModel.fromJson(userCourse))
            .toList();
        return userCourses;
      }
      return null;
    } catch (e) {
      print(e.toString());
      throw CacheException();
    }
  }

  @override
  Future<void> saveUserCourses(dynamic userCourses) async {
    // await Hive.openBox('homeBox');
    await _courseBox.put('userCourses', userCourses);
  }

  @override
  Future<UserCourseAnalysis?> getCachedCourseById(String id) async {
    try {
      final rawData = await _courseBox.get(id);
      if (rawData != null) {
        final courseJson = json.decode(rawData)['data'];
        final course = UserCourseAnalysisModel.fromJson(courseJson);
        return course;
      }
      return null;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> saveCourseById({
    required String id,
    required dynamic userCourseAnalysisJson,
  }) async {
    try {
      await _courseBox.put(id, userCourseAnalysisJson);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheCourseVideos(String courseId, dynamic courseVideos) async {
    await _courseBox.put('courseVideos-$courseId', courseVideos);
  }

  @override
  Future<List<ChapterVideoModel>?> getCachedCourseVideos(
      String courseId) async {
    try {
      final rawData = await _courseBox.get('courseVideos-$courseId');
      if (rawData != null) {
        final data = json.decode(rawData)['data'];
        return (data ?? [])
            .map<ChapterVideoModel>(
              (chapterVideo) => ChapterVideoModel.fromJson(chapterVideo),
            )
            .toList();
      }
      return null;
    } catch (e) {
      throw CacheException();
    }
  }
}
