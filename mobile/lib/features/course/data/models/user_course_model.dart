import '../../../features.dart';

class UserCourseModel extends UserCourse {
  const UserCourseModel({
    required super.id,
    required super.userId,
    required super.course,
    required super.completedChapters,
  });

  factory UserCourseModel.fromJson(Map<String, dynamic> json) {
    return UserCourseModel(
      id: json['_id'],
      userId: json['userId'],
      course: CourseModel.fromUserCourseJson(json['course']),
      completedChapters: json['completedChapters'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'course': ((x) => CourseModel.fromJson(x)),
      'completedChapters': completedChapters
    };
  }
}
