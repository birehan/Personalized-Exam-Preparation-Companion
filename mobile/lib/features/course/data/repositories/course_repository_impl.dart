import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:prepgenie/core/constants/app_keys.dart';
import 'package:prepgenie/core/utils/hive_boxes.dart';
import 'package:prepgenie/features/course/data/datasources/courses_local_data_sources.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class CourseRepositoryImpl implements CourseRepositories {
  final CourseRemoteDataSource remoteDataSource;
  final CoursesLocalDatasource coursesLocalDatasource;
  final NetworkInfo networkInfo;
  final FlutterSecureStorage flutterSecureStorage;

  CourseRepositoryImpl(
      {required this.networkInfo,
      required this.remoteDataSource,
      required this.coursesLocalDatasource,
      required this.flutterSecureStorage});

  @override
  Future<Either<Failure, List<Course>>> allCourses(String departmentId) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<UserCourse>>> getUserCourses(bool refresh) async {
    try {
      if (!await networkInfo.isConnected) {
        final userCourses = await coursesLocalDatasource.getCachedUserCourses();
        if (userCourses != null) {
          return Right(userCourses);
        }
        return Left(NetworkFailure());
      }
      final userCourse = await remoteDataSource.getUserCourses();
      return Right(userCourse);
    } catch (e) {
      return Left(await mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, UserCourseAnalysis>> getCourseById({
    required String id,
    required bool isRefreshed,
  }) async {
    try {
      if (!await networkInfo.isConnected) {
        final cachedCourse =
            await coursesLocalDatasource.getCachedCourseById(id);
        if (cachedCourse != null) {
          return Right(cachedCourse);
        }
        return Left(NetworkFailure());
      }

      final course = await remoteDataSource.getCourseById(id);
      return Right(course);
    } catch (e) {
      return Left(await mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<Course>>> getCoursesByDepartmentId(
      String id) async {
    try {
      if (await networkInfo.isConnected) {
        final List<Course> courses =
            await remoteDataSource.getCoursesByDepartmentId(id);
        return Right(courses);
      } else {
        return Left(NetworkFailure());
      }
    } catch (e) {
      return Left(await mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, bool>> registerCourse(String courseId) async {
    if (await networkInfo.isConnected) {
      try {
        bool response = await remoteDataSource.registercourse(courseId);
        return Right(response);
      } catch (e) {
        return Left(await mapExceptionToFailure(e));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> registerSubChapter(
      String subChapter, String chapterId) async {
    if (await networkInfo.isConnected) {
      try {
        bool response =
            await remoteDataSource.registerSubChapter(subChapter, chapterId);
        return Right(response);
      } catch (e) {
        return Left(await mapExceptionToFailure(e));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, DepartmentCourse>> getDepartmentCourse(
      String id) async {
    if (await networkInfo.isConnected) {
      try {
        final departmentCourse = await remoteDataSource.getDepartmentCourse(id);
        return Right(departmentCourse);
      } catch (e) {
        return Left(await mapExceptionToFailure(e));
      }
    }
    return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, ChatResponse>> chat(bool isContest, String questionId,
      String userQuestion, List<ChatHistory> chatHistory) async {
    if (await networkInfo.isConnected) {
      try {
        final chatResponse = await remoteDataSource.chat(
            isContest, questionId, userQuestion, chatHistory);
        return Right(chatResponse);
      } catch (e) {
        return Left(await mapExceptionToFailure(e));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<ChapterVideo>>> fetchCourseVideos(
      String courseId) async {
    try {
      if (await networkInfo.isConnected) {
        final courseVideos = await remoteDataSource.fetchCourseVideos(courseId);
        return Right(courseVideos);
      } else {
        final courseVideos =
            await coursesLocalDatasource.getCachedCourseVideos(courseId);
        if (courseVideos != null) {
          return Right(courseVideos);
        }
        return Left(NetworkFailure());
      }
    } catch (e) {
      return Left(await mapExceptionToFailure(e));
    }
  }
}
