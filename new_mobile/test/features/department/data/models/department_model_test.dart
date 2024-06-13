import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:prep_genie/features/features.dart';
import '../../../../fixtures/fixture_reader.dart';

void main() {
  const department = DepartmentModel(
      description: "description",
      generalDepartmentId: "id",
      id: "id",
      name: "name",
      numberOfCourses: 5);

  test('should be a subclass of course entity', () async {
    // assert
    expect(department, isA<Department>());
  });

  group('fromJson', () {
    test('should return a valid model when the JSON is recieved', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('department/department.json'));
      // act
      final result = DepartmentModel.fromJson(jsonMap);
      // assert
      expect(result, department);
    });
  });
}
