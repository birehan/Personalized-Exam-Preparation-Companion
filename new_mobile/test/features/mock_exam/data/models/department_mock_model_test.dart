import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:prep_genie/features/features.dart';
import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tId = "English";
  const mockExams = [
    MockExamModel(
        id: "65409e6055ae50031e35167f",
        name: "English Entrance Exam",
        departmentId: "64c24df185876fbb3f8dd6c7",
        examYear: "2013",
        numberOfQuestions: 120)
  ];

  const departmentMock = DepartmentMockModel(id: tId, mockExams: mockExams);

  test('should be a department Mock of Department Mock entity', () async {
    // assert
    expect(departmentMock, isA<DepartmentMock>());
  });

  group('fromJson', () {
    test('should return a valid model when the JSON is recieved', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('mock_exam/department_mock.json'));
      // act
      final result = DepartmentMockModel.fromJson(jsonMap);
      // assert
      expect(result, departmentMock);
    });
  });
}
