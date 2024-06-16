import '../../../features.dart';

class CourseModel extends Course {
  const CourseModel({
    required super.id,
    required super.name,
    required super.departmentId,
    required super.description,
    required super.numberOfChapters,
    required super.ects,
    required super.image,
    super.referenceBook,
    required super.grade,
    required super.isNewCurriculum,
    required super.chapters,
  });

  factory CourseModel.fromDepartmentCourseJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['_id'] ?? '',
      departmentId: json['departmentId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      ects: json['ECTS'] != null ? json['ECTS'].toString() : '0',
      numberOfChapters: json['noOfChapters'] ?? 0,
      image: CourseImageModel(
          imageAddress: json['image'] != null &&
                  json['image']['imageAddress'] != null
              ? json['image']['imageAddress']
              : 'https://res.cloudinary.com/djrfgfo08/image/upload/v1697788701/SkillBridge/mobile_team_icons/j4byd2jp9sqqc4ypxb5d.png'),
      referenceBook: json['referenceBook'] ?? '',
      grade: json['grade'] ?? 0,
      isNewCurriculum: json['curriculum'] ?? false,
      chapters: (json['chapters'] ?? [])
          .map<ChapterModel>((chapter) => ChapterModel.fromJson(chapter))
          .toList(),
    );
  }

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['_id'] ?? '',
      departmentId: json['departmentId']['name'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      ects: json['ECTS'] != null ? json['ECTS'].toString() : '0',
      numberOfChapters: json['noOfChapters'] ?? 0,
      image: CourseImageModel(
          imageAddress: json['image'] != null &&
                  json['image'] is! String &&
                  json['image']['imageAddress'] != null
              ? json['image']['imageAddress']
              : 'https://res.cloudinary.com/djrfgfo08/image/upload/v1697788701/SkillBridge/mobile_team_icons/j4byd2jp9sqqc4ypxb5d.png'),
      referenceBook: json['reference_book'] ?? '',
      grade: json['grade'] ?? 0,
      isNewCurriculum: json['curriculum'] ?? false,
      chapters: (json['courseChapters'] ?? [])
          .map<ChapterModel>((chapter) => ChapterModel.fromJson(chapter))
          .toList(),
    );
  }

  factory CourseModel.fromDownloadCourseJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['_id'] ?? '',
      departmentId: json['departmentId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      ects: json['ECTS'] != null ? json['ECTS'].toString() : '0',
      numberOfChapters: json['noOfChapters'] ?? 0,
      image: CourseImageModel(
          imageAddress: json['image'] != null &&
                  json['image'] is! String &&
                  json['image']['imageAddress'] != null
              ? json['image']['imageAddress']
              : 'https://res.cloudinary.com/djrfgfo08/image/upload/v1697788701/SkillBridge/mobile_team_icons/j4byd2jp9sqqc4ypxb5d.png'),
      referenceBook: json['reference_book'] ?? '',
      grade: json['grade'] ?? 0,
      isNewCurriculum: json['curriculum'] ?? false,
      chapters: (json['courseChapters'] ?? [])
          .map<ChapterModel>(
              (chapter) => ChapterModel.fromDownloadCourseJson(chapter))
          .toList(),
    );
  }

  factory CourseModel.fromUserCourseJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['_id'] ?? '',
      departmentId: json['departmentId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      ects: (json['ECTS'] ?? 0).toString(),
      numberOfChapters: json['noOfChapters'] ?? 0,
      image: CourseImageModel(
          imageAddress: json['image'] != null &&
                  json['image'] is! String &&
                  json['image']['imageAddress'] != null
              ? json['image']['imageAddress']
              : 'https://res.cloudinary.com/djrfgfo08/image/upload/v1697788701/SkillBridge/mobile_team_icons/j4byd2jp9sqqc4ypxb5d.png'),
      referenceBook: json['reference_book'] ?? '',
      grade: json['grade'] ?? 0,
      isNewCurriculum: json['curriculum'] ?? false,
      chapters: (json['chapters'] ?? [])
          .map<ChapterModel>((chapter) => ChapterModel.fromJson(chapter))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'departmentId': departmentId,
      'name': name,
      'description': description,
      'ECTS': ects,
      'no_of_chapters': numberOfChapters,
      'image': image,
      'referense_book': referenceBook,
    };
  }
}
