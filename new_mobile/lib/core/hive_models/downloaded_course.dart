import 'package:hive/hive.dart';

part 'downloaded_course.g.dart';

@HiveType(typeId: 1)
class DownloadedCourse {
  @HiveField(0)
  final String courseId;

  DownloadedCourse(this.courseId);
}
