import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:skill_bridge_mobile/features/features.dart';
import '../../../../fixtures/fixture_reader.dart';

void main() {
  const department = [
    DepartmentModel(
        description: "description",
        generalDepartmentId: "id",
        id: "id",
        name: "name",
        numberOfCourses: 5)
  ];

  const generalDepartment = GeneralDepartmentModel(
      id: "id",
      name: "name",
      description: "description",
      departments: department,
      isForListing: false);

  test('should be a subclass of course entity', () async {
    // assert
    expect(generalDepartment, isA<GeneralDepartment>());
  });

  group('fromJson', () {
    test('should return a valid model when the JSON is recieved', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('department/general_department.json'));
      // act
      final result = GeneralDepartmentModel.fromJson(jsonMap);
      // assert
      expect(result, generalDepartment);
    });
  });
}
