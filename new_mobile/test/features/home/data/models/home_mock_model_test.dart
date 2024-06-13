import 'package:flutter_test/flutter_test.dart';
import 'package:prep_genie/features/home/data/models/home_mock_model.dart';

void main() {
  group('HomeMockModel', () {
    test('fromJson() should parse JSON correctly', () {
      // Example JSON data
      Map<String, dynamic> json = {
        '_id': 'mock_id',
        'name': 'Mock Name',
        'departmentId': 'department_id',
        'examYear': "2024",
        'subject': 'Mock Subject',
        'questions': 20,
      };

      // Parse JSON into model
      final homeMockModel = HomeMockModel.fromJson(json);

      // Assertions
      expect(homeMockModel.id, 'mock_id');
      expect(homeMockModel.name, 'Mock Name');
      expect(homeMockModel.departmentId, 'department_id');
      expect(homeMockModel.examYear, "2024");
      expect(homeMockModel.subject, 'Mock Subject');
      expect(homeMockModel.numberOfQuestions, 20);
    });
  });
}
