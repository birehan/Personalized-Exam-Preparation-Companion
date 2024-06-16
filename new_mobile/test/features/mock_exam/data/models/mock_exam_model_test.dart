import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:prep_genie/features/features.dart';
import '../../../../fixtures/fixture_reader.dart';

void main() {
  const questions = [
    QuestionModel(
        isLiked: false,
        id: "649448dbf296abbe4531d110",
        courseId: "64943fd3f296abbe4531d06b",
        chapterId: "649440e9f296abbe4531d06f",
        subChapterId: "649441bbf296abbe4531d077",
        description:
            "What is the benefit of using an intranet within an organization?",
        choiceA: "Improved productivity and collaboration",
        choiceB: "Access to the global network",
        choiceC: "Enhanced security for online transactions",
        choiceD: "Ability to connect with other organizations",
        answer: "choice_A",
        explanation:
            "Using an intranet within an organization can improve productivity, streamline communication, and enhance collaboration among employees.",
        isForQuiz: true)
  ];
  const mockExamsFromDepartment = MockExamModel(
      id: "65409e6055ae50031e35167f",
      name: "English Entrance Exam",
      departmentId: "64c24df185876fbb3f8dd6c7",
      examYear: "2013",
      numberOfQuestions: 120);
  const mockExams = MockExamModel(
      id: "65409e6055ae50031e35167f",
      name: "English Entrance Exam",
      departmentId: "64c24df185876fbb3f8dd6c7",
      examYear: "2013",
      questions: questions);

  test('should be a department Mock of Department Mock entity', () async {
    // assert
    expect(mockExams, isA<MockExam>());
    expect(mockExams, isA<MockExam>());
  });

  group('fromDepartmentMocksJson', () {
    test('should return a valid model when the JSON is recieved', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('mock_exam/mock_exam_from_department.json'));
      // act
      final result = MockExamModel.fromDepartmentMocksJson(jsonMap);
      // assert
      expect(result, mockExamsFromDepartment);
    });
  });

  group('fromJson', () {
    test('should return a valid model when the JSON is recieved', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('mock_exam/mock_exam.json'));
      // act
      final result = MockExamModel.fromJson(jsonMap);
      // assert
      // expect(result, mockExams);
    });
  });
}
