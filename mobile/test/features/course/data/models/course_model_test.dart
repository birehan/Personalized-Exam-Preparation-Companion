import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:prepgenie/features/course/course.dart';
import '../../../../fixtures/fixture_reader.dart';

void main() {
  const courseModel = CourseModel(
      id: "6530d7be128c1e08e946dee6",
      name: "Biology",
      grade: 12,
      description:
          "This course explores Grade 12 Biology , offering concise subtopic summaries for each chapter. You'll also find quizzes to test your understanding, with the freedom to choose the chapters you want to focus on. The End of Chapter section includes National Exam questions and similar questions, neatly organized within corresponding chapters for your convenience.",
      ects: "10",
      referenceBook: "Grade 12 Biology",
      numberOfChapters: 5,
      departmentId: "64c24df185876fbb3f8dd6c7",
      image: CourseImageModel(
          imageAddress:
              "https://res.cloudinary.com/djrfgfo08/image/upload/v1698237821/SkillBridge/hixwf8xe7kugefiniy1m.png"),
      cariculumIsNew: false);

  const courseDepartment = CourseModel(
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
      cariculumIsNew: false);

 

  test('should be a subclass of course entity', () async {
    // assert
    expect(courseModel, isA<Course>());
  });

  group('fromJson', () {
    test('should return a valid model when the JSON is recieved', () async {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('course.json'));
      // act
      final result = CourseModel.fromJson(jsonMap);
      // assert
      expect(result, courseModel);
    });

    test('should return a calid model when the JSON is recieved', () async {
      // arramge
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('course_department.json'));
      // act
      final result = CourseModel.fromDepartmentCourseJson(jsonMap);
      // assert
      expect(result, courseDepartment);
    });
  });

  group('toJson', () {
    test('should return a Json map containing the proper data', () async {
      // act
      final result = courseModel.toJson();
      // assert
      final expectedJsonMap = {
        "_id": "6530d7be128c1e08e946dee6",
        "name": "Biology",
        "description":
            "This course explores Grade 12 Biology , offering concise subtopic summaries for each chapter. You'll also find quizzes to test your understanding, with the freedom to choose the chapters you want to focus on. The End of Chapter section includes National Exam questions and similar questions, neatly organized within corresponding chapters for your convenience.",
        "ECTS": "10",
        "referense_book": "Grade 12 Biology",
        "no_of_chapters": 5,
        "departmentId": "64c24df185876fbb3f8dd6c7",
        "image": CourseImageModel(
            imageAddress:
                "https://res.cloudinary.com/djrfgfo08/image/upload/v1698237821/SkillBridge/hixwf8xe7kugefiniy1m.png"),
      };
      expect(result, expectedJsonMap);
    });
  });
}


