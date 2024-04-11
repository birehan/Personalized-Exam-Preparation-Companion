import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:prepgenie/features/authentication/data/models/user_credential_model.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  group('UserCredentialModel', () {
    test('fromJson should create a valid UserCredentialModel', () {
      // Arrange
      const json = {
        'curUser': {
          '_id': '1',
          'email_phone': 'test@example.com',
          'firstName': 'John',
          'lastName': 'Doe',
          'department': {'name': 'Computer Science', '_id': 'cs123'},
          'token': 'token123',
          'avatar': {'imageAddress': 'avatar_url'},
        },
        'token': 'token123',
      };

      // Act
      final userCredentialModel = UserCredentialModel.fromJson(json);

      // Assert
      expect(userCredentialModel.id, '1');
      expect(userCredentialModel.email, 'test@example.com');
      expect(userCredentialModel.firstName, 'John');
      expect(userCredentialModel.lastName, 'Doe');
      expect(userCredentialModel.department, 'Computer Science');
      expect(userCredentialModel.departmentId, 'cs123');
      expect(userCredentialModel.token, 'token123');
      expect(userCredentialModel.profileAvatar, 'avatar_url');
    });

    test('fromJson should handle missing fields', () {
      // Arrange
      const json = {
        'curUser': {
          'email_phone': 'test@example.com',
          'firstName': 'John',
          'lastName': 'Doe',
        },
      };

      // Act
      final userCredentialModel = UserCredentialModel.fromJson(json);

      // Assert
      expect(userCredentialModel.id, '');
      expect(userCredentialModel.department, null);
    });

    test('fromJson should handle null values', () {
      // Arrange
      const json = {
        'curUser': {
          '_id': null,
          'email_phone': null,
          'firstName': null,
          'lastName': null,
        },
        'token': null,
      };

      // Act
      final userCredentialModel = UserCredentialModel.fromJson(json);

      // Assert
      expect(userCredentialModel.id, '');
      expect(userCredentialModel.email, '');
    });

    group('fromJson', () {
      test('should return a valid model when the JSON is received', () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('authentication/user_credential.json'));
        // act
        final result = UserCredentialModel.fromJson(jsonMap);
        // assert
        expect(result.id, '1');
        expect(result.email, 'test@example.com');
        expect(result.firstName, 'John');
        expect(result.lastName, 'Doe');
      });

      test(
          'should return a valid model when the JSON is received for updated user',
          () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('authentication/updated_user_credential.json'));
        // act
        final result = UserCredentialModel.fromUpdatedUserJson(jsonMap);
        // assert
        expect(result.id, '1');
        expect(result.email, 'test@example.com');
        expect(result.firstName, 'John');
        expect(result.lastName, 'Doe');
      });

      test(
          'should return a valid model when the JSON is received from local cache',
          () async {
        // arrange
        final Map<String, dynamic> jsonMap = json.decode(
            fixture('authentication/local_cached_user_credential.json'));
        // act
        final result = UserCredentialModel.fromLocalCachedJson(jsonMap);
        // assert
        expect(result.id, '1');
        expect(result.email, 'test@example.com');
        expect(result.firstName, 'John');
        expect(result.lastName, 'Doe');
      });
    });

    group('toJson', () {
      test('should return a JSON map containing the proper data', () async {
        // arrange
        const userCredentialModel = UserCredentialModel(
          id: '1',
          email: 'test@example.com',
          firstName: 'John',
          lastName: 'Doe',
          // Add values for other fields
        );
        // act
        final result = userCredentialModel.toJson(userCredentialModel);
        // assert
        expect(result['id'], '1');
        expect(result['email'], 'test@example.com');
        expect(result['firstName'], 'John');
        expect(result['lastName'], 'Doe');
      });
    });
  });
}
