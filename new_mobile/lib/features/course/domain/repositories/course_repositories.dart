import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

abstract class CourseRepositories {
  Future<Either<Failure, List<Course>>> allCourses(String departmentId);
  Future<Either<Failure, List<UserCourse>>> getUserCourses(bool refresh);

  Future<Either<Failure, UserCourseAnalysis>> getCourseById({
    required String id,
    required bool isRefreshed,
  });
  Future<Either<Failure, List<Course>>> getCoursesByDepartmentId(String id);
  Future<Either<Failure, bool>> registerCourse(String courseId);
  Future<Either<Failure, bool>> registerSubChapter(
      String subChapter, String chapterId);

  Future<Either<Failure, DepartmentCourse>> getDepartmentCourse(String id);

  Future<Either<Failure, ChatResponse>> chat(
    bool isContest,
    String questionId,
    String userQuestion,
    List<ChatHistory> chatHistory,
  );
  Future<Either<Failure, List<ChapterVideo>>> fetchCourseVideos(
      
      String courseId);
  Future<Either<Failure, Unit>> downloadCourseById(String courseId);
  Future<Either<Failure, List<Course>>> fetchDownloadedCourses();
  Future<Either<Failure, Unit>> markCourseAsDownloaded(String courseId);
  Future<Either<Failure, bool>> isCourseDownloaded(String courseId);
  Future<Either<Failure, bool>> updateVideoStatus(
      {required String videoId, required bool isCompleted});
}
