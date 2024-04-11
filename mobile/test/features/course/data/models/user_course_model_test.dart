import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:skill_bridge_mobile/features/course/course.dart';
import '../../../../fixtures/fixture_reader.dart';

void main() {
  const userCourse = UserCourseModel(
      id: "65c536893a192c185aa9b51b",
      userId: "65c536543a192c185aa9b4ea",
      completedChapters: 1,
      course: CourseModel(
          id: "6530d803128c1e08e946def8",
          name: "Biology",
          grade: 11,
          description:
              "This course explores Grade 11 Biology , offering concise subtopic summaries for each chapter. You'll also find quizzes to test your understanding, with the freedom to choose the chapters you want to focus on. The End of Chapter section includes National Exam questions and similar questions, neatly organized within corresponding chapters for your convenience.",
          ects: "10",
          referenceBook: "Grade 11 Biology",
          numberOfChapters: 5,
          departmentId: "64c24df185876fbb3f8dd6c7",
          image: CourseImageModel(
              imageAddress:
                  "https://res.cloudinary.com/djrfgfo08/image/upload/v1698238074/SkillBridge/k9ajmykrzoihaqrnesgu.png"),
          cariculumIsNew: false));

  test('should be a subclass of user course entity', () async {
    // assert
    expect(userCourse, isA<UserCourse>());
  });

  group('fromJson', () {
    test('should return a valid model when the JSON is recieved', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('user_course.json'));
      // act
      final result = UserCourseModel.fromJson(jsonMap);
      // assert
      expect(result, userCourse);
    });
  });

  group('toJson', () {
    test('should return a Json map containing the proper data', () async {
      // act
      final result = userCourse.toJson();
      // assert

      final expectedJsonMap = {
        '_id': '65c536893a192c185aa9b51b',
        'userId': '65c536543a192c185aa9b4ea',
        'course': {
          '_id': '6530d803128c1e08e946def8',
          'departmentId': '64c24df185876fbb3f8dd6c7',
          'name': 'Biology',
          'description':
              'This course explores Grade 11 Biology , offering concise subtopic summaries for each chapter. You\'ll also find quizzes to test your understanding, with the freedom to choose the chapters you want to focus on. The End of Chapter section includes National Exam questions and similar questions, neatly organized within corresponding chapters for your convenience.',
          'ECTS': '10',
          'no_of_chapters': 5,
          'image': CourseImageModel(
            imageAddress:
                 "https://res.cloudinary.com/djrfgfo08/image/upload/v1698238074/SkillBridge/k9ajmykrzoihaqrnesgu.png"),
          'referense_book': null
        },
        'completedChapters': 1
      };
      expect(result, expectedJsonMap);
    });
  });
}

