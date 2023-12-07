import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class CourseRepositoryImpl implements CourseRepositories {
  final CourseRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  CourseRepositoryImpl({
    required this.networkInfo,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<Course>>> allCourses(String departmentId) {
    // TODO: implement allCourses
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<UserCourse>>> getUserCourses() async {
    if (await networkInfo.isConnected) {
      try {
        final userCourse = await remoteDataSource.getUserCourses();
        return Right(userCourse);
      } catch (e) {
        return Left(mapExceptionToFailure(e));
      }
    }
    return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, UserCourseAnalysis>> getCourseById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final course = await remoteDataSource.getCourseById(id);
        return Right(course);
      } catch (e) {
        return Left(mapExceptionToFailure(e));
      }
    }
    return Left(NetworkFailure());
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
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, bool>> registerCourse(String courseId) async {
    if (await networkInfo.isConnected) {
      try {
        bool response = await remoteDataSource.registercourse(courseId);
        return Right(response);
      } catch (e) {
        return Left(mapExceptionToFailure(e));
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
        return Left(mapExceptionToFailure(e));
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
        return Left(mapExceptionToFailure(e));
      }
    }
    return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, ChatResponse>> chat(String questionId,
      String userQuestion, List<ChatHistory> chatHistory) async {
    if (await networkInfo.isConnected) {
      try {
        final chatResponse =
            await remoteDataSource.chat(questionId, userQuestion, chatHistory);
        return Right(chatResponse);
      } catch (e) {
        return Left(mapExceptionToFailure(e));
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
