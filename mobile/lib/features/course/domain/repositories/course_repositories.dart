import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

abstract class CourseRepositories {
  Future<Either<Failure, List<Course>>> allCourses(String departmentId);
  Future<Either<Failure, List<UserCourse>>> getUserCourses();

  Future<Either<Failure, UserCourseAnalysis>> getCourseById(String id);
  Future<Either<Failure, List<Course>>> getCoursesByDepartmentId(String id);
  Future<Either<Failure, bool>> registerCourse(String courseId);
  Future<Either<Failure, bool>> registerSubChapter(
      String subChapter, String chapterId);

  Future<Either<Failure, DepartmentCourse>> getDepartmentCourse(String id);

  Future<Either<Failure, ChatResponse>> chat(
    String questionId,
    String userQuestion,
    List<ChatHistory> chatHistory,
  );
}
