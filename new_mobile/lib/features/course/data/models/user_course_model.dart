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
    final courseModel = CourseModel(
      id: course.id,
      name: course.name,
      departmentId: course.departmentId,
      description: course.description,
      numberOfChapters: course.numberOfChapters,
      ects: course.ects,
      image: course.image,
      grade: course.grade,
      isNewCurriculum: course.isNewCurriculum,
      chapters: course.chapters,
    );
    return {
      '_id': id,
      'userId': userId,
      'course': courseModel.toJson(),
      'completedChapters': completedChapters
    };
  }
}
