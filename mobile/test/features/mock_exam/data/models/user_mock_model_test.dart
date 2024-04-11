import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:skill_bridge_mobile/features/features.dart';
import '../../../../fixtures/fixture_reader.dart';

void main() {
  const userMock = UserMockModel(id: "64954a111a381d8c0955f3cb", name:  "Elictraical Mock", numberOfQuestions: 100, departmentId: "64943ec6f296abbe4531d069", isCompleted: true, score: 2);

  test('should be a user Mock of user Mock entity', () async {
    // assert
    expect(userMock, isA<UserMock>());
  });

  group('fromJson', () {
    test('should return a valid model when the JSON is recieved', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('mock_exam/user_mock_model.json'));
      // act
      final result = UserMockModel.fromJson(jsonMap);
      // assert
      expect(result, userMock);
    });
  });
}
