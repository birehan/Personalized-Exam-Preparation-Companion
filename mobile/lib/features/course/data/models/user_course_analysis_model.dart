import '../../../features.dart';

class UserCourseAnalysisModel extends UserCourseAnalysis {
  const UserCourseAnalysisModel({
    required super.course,
    required super.userChaptersAnalysis,
  });

  factory UserCourseAnalysisModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> analysisList = json['userChapterAnalysis'];
    // print(analysisList);
    List<UserChapterAnalysis> userChaptersAnalysis = analysisList
        .map(
          (course) => UserChapterAnalysisModel.fromJson(course),
        )
        .toList();
    return UserCourseAnalysisModel(
        course: CourseModel.fromJson(json['course']),
        userChaptersAnalysis: userChaptersAnalysis);
  }
}
