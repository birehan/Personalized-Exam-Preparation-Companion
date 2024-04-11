import '../../domain/entities/course_image.dart';

class CourseImageModel extends CourseImage {
  const CourseImageModel({required super.imageAddress});

  factory CourseImageModel.fromJson(Map<String, dynamic> json) {
    return CourseImageModel(
      imageAddress: json['imageAddress'],
    );
  }
}
