import 'package:flutter_test/flutter_test.dart';
import 'package:prep_genie/features/home/data/models/home_chapter_model.dart';

void main() {
  group('HomeChapterModel', () {
    test('fromJson() should parse JSON correctly', () {
      // Example JSON data
      Map<String, dynamic> json = {
        'summary': 'Summary',
        '_id': 'chapter_id',
        'name': 'Chapter Name',
        'description': 'Chapter Description',
        'courseId': {'_id': 'course_id', 'name': 'Course Name'},
        'noOfSubChapters': 3,
      };

      // Parse JSON into model
      final homeChapter = HomeChapterModel.fromJson(json);

      // Assertions
      expect(homeChapter.summary, 'Summary');
      expect(homeChapter.id, 'chapter_id');
      expect(homeChapter.name, 'Chapter Name');
      expect(homeChapter.description, 'Chapter Description');
      expect(homeChapter.courseId, 'course_id');
      expect(homeChapter.courseName, 'Course Name');
      expect(homeChapter.noOfSubChapters, 3);
    });
  });
}
