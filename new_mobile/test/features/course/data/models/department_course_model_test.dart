import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:prep_genie/features/course/course.dart';
import 'package:prep_genie/features/course/data/models/department_course_model.dart';
import '../../../../fixtures/fixture_reader.dart';

void main() {
  const courseDepartment = [
    CourseModel(
        id: "6589685d52f4ffeace920fec",
        name: "Biology",
        grade: 9,
        description:
            "This course explores Grade 9 Biology , offering concise subtopic summaries for each chapter. You'll also find quizzes to test your understanding, with the freedom to choose the chapters you want to focus on. The End of Chapter section includes National Exam questions and similar questions, neatly organized within corresponding chapters for your convenience.",
        ects: "10",
        referenceBook: "Grade 9 Biology",
        numberOfChapters: 8,
        departmentId: "65898c5b52f4ffeace9210e6",
        image: CourseImageModel(
            imageAddress:
                "https://res.cloudinary.com/djrfgfo08/image/upload/v1698237821/SkillBridge/hixwf8xe7kugefiniy1m.png"),
        cariculumIsNew: false)
  ];

  const departmentCourse = DepartmentCourseModel(
      biology: courseDepartment,
      chemistry: [],
      civics: [],
      english: [],
      maths: [],
      physics: [],
      sat: [],
      others: [],
      economics: [],
      history: [],
      geography: [],
      business: []);

  test('should be a department course of course entity', () async {
    // assert
    expect(departmentCourse, isA<DepartmentCourse>());
  });

  group('fromJson', () {
    test('should return a valid model when the JSON is recieved', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('department_course.json'));
      // act
      final result = DepartmentCourseModel.fromJson(jsonMap);
      // assert
      expect(result, departmentCourse);
    });
  });
}
