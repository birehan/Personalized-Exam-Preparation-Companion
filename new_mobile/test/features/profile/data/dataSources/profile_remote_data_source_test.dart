import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prep_genie/core/constants/app_keys.dart';
import 'package:prep_genie/core/error/exception.dart';
import 'package:prep_genie/features/features.dart';
import 'package:http/http.dart' as http;
import 'package:prep_genie/features/profile/data/models/user_profile_model.dart';
import '../../../../fixtures/fixture_reader.dart';
import '../../../course/data/datasources/course_remote_datasource_test.mocks.dart';
import '../../../course/data/repositories/course_repository_impl_test.mocks.dart';
import '../repository/profile_repositories_impl_test.mocks.dart';

void main() {
  late MockProfileLocalDataSource mockLocalDataSource;
  late MockHttpClient mockClient;
  late MockFlutterSecureStorage mockSecureStorage;
  late ProfileRemoteDataSourceImpl profileRemoteDataSourceImple;

  setUp(() {
    mockClient = MockHttpClient();
    mockLocalDataSource = MockProfileLocalDataSource();
    mockSecureStorage = MockFlutterSecureStorage();
    profileRemoteDataSourceImple = ProfileRemoteDataSourceImpl(
      client: mockClient,
      flutterSecureStorage: mockSecureStorage,
      profileLocalDataSource: mockLocalDataSource,
    );
  });
  const mockToken =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6eyJnZW5kZXIiOiJNYWxlL0ZlbWFsZSIsImhpZ2hTY2hvb2wiOiJNeSBTY2hvb2wiLCJyZWdpb24iOiJNeSByZWdpb24iLCJncmFkZSI6MTIsIl9pZCI6IjY1MzhmOTUyOTU3YTgwMWRmYjVlOWM1MiIsImVtYWlsX3Bob25lIjoieW9oYW5uZXNrZXRlbWF6ZWxla2VAZ21haWwuY29tIiwiZmlyc3ROYW1lIjoiWW9oYW5uZXMiLCJsYXN0TmFtZSI6IktldGVtYSIsInBhc3N3b3JkIjoiJDJiJDEwJEJ1OWFTVVZHM1lhMnd1bUNLUTJuSWVRSTByUFNMZGJNLkZJdnVWTkk2YTVFZkZRSXVqdzNXIiwiZGVwYXJ0bWVudCI6IjY0YzI0ZGYxODU4NzZmYmIzZjhkZDZjNyIsImF2YXRhciI6bnVsbCwicmVzZXRUb2tlbiI6IiIsImhvd1ByZXBhcmVkIjoiIiwicHJlZmVycmVkTWV0aG9kIjoiIiwic3R1ZHlUaW1lUGVyRGF5IjoiIiwibW90aXZhdGlvbiI6IiIsImNoYWxsZW5naW5nU3ViamVjdHMiOltdLCJyZW1pbmRlciI6IiIsImNyZWF0ZWRBdCI6IjIwMjMtMTAtMjVUMTE6MTc6MzguNzIzWiIsInVwZGF0ZWRBdCI6IjIwMjQtMDEtMTVUMTM6MTY6MDcuMjIwWiIsIl9fdiI6MH0sImlhdCI6MTcwOTUzODYzMywiZXhwIjoxNzEyMTMwNjMzfQ.UPow5VgmQdxqtF227bFC5_miYgaUXaWe9Us6aOOGJdk';
  const userModel = UserProfileModel(
    id: 'id',
    consistecy: [],
    email: 'nigatu@a2sv.org',
    firstName: 'dean',
    lastName: 'Henderson',
    profileImage:
        'https://res.cloudinary.com/djrfgfo08/image/upload/v1705500006/SkillBridge/s9own3tjc61kah8eym6s.png',
    topicsCompleted: 53,
    chaptersCompleted: 3,
    questionsSolved: 235,
    totalScore: 24,
    rank: 4,
    maxStreak: 0,
    points: 0,
    currentStreak: 0,
    examType: 'University Entrance Exam',
    howPrepared: '',
    preferedMethod: '',
    studyTimePerDay: '',
    motivation: '',
    reminder: '',
    departmentId: '64c24df185876fbb3f8dd6c7',
    departmentName: 'Natural Science',
  );
  group('getUserProfile', () {
    test('should return a current user profile information', () async {
      // Mocking necessary methods and data
      const token = mockToken;
      final userModelJson = {'token': token};

      when(mockSecureStorage.read(key: authenticationKey))
          .thenAnswer((_) async => json.encode(userModelJson));

      when(mockClient.get(Uri.parse('$baseUrl/user/currentUser'),
              headers: anyNamed('headers')))
          .thenAnswer(
              (_) async => http.Response(fixture('profile/user.json'), 200));

      final result = await profileRemoteDataSourceImple.getUserProfile();

      // Assertion
      expect(result, userModel);
    });
    test('should return a user profile information of a certain user',
        () async {
      // Mocking necessary methods and data
      const token = mockToken;
      final userModelJson = {'token': token};

      when(mockSecureStorage.read(key: authenticationKey))
          .thenAnswer((_) async => json.encode(userModelJson));

      when(mockClient.get(Uri.parse('$baseUrl/user/leaderboard/getUser/userId'),
              headers: anyNamed('headers')))
          .thenAnswer(
              (_) async => http.Response(fixture('profile/user.json'), 200));

      final result =
          await profileRemoteDataSourceImple.getUserProfile(userId: 'userId');

      // Assertion
      expect(result, userModel);
    });

    test('should throw RequestOverloadException when status code is 429',
        () async {
      // Mocking necessary methods and data
      const token = mockToken;
      final userModelJson = {'token': token};

      when(mockSecureStorage.read(key: authenticationKey))
          .thenAnswer((_) async => json.encode(userModelJson));

      when(mockClient.get(Uri.parse('$baseUrl/user/currentUser'),
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Too Many Request', 429));

      // Assertion
      expect(() async => await profileRemoteDataSourceImple.getUserProfile(),
          throwsA(const TypeMatcher<RequestOverloadException>()));
    });
  });

  group('change password', () {
    test('should return changePasswrodmodel instance', () async {
      // Mocking necessary methods and data
      const token = mockToken;
      final userModelJson = {'token': token};

      when(mockSecureStorage.read(key: authenticationKey))
          .thenAnswer((_) async => json.encode(userModelJson));
      Map<String, String> requestBody = {
        'oldPassword': 'oldPassword',
        'newPassword': 'newPassword',
        'confirmPassword': 'newPassword'
      };

      String jsonBody = json.encode(requestBody);

      when(mockClient.post(Uri.parse('$baseUrl/user/userChangePassword'),
              headers: anyNamed('headers'), body: jsonBody))
          .thenAnswer(
        (_) async => http.Response(fixture('profile/changePassword.json'), 200),
      );

      final result = await profileRemoteDataSourceImple.postChangePassword(
          'oldPassword', 'newPassword', 'newPassword');

      // Assertion
      expect(result, equals(const ChangePasswordModel()));
    });

    test('should throw RequestOverloadException when status code is 429',
        () async {
      // Mocking necessary methods and data
      const token = mockToken;
      final userModelJson = {'token': token};

      when(mockSecureStorage.read(key: authenticationKey))
          .thenAnswer((_) async => json.encode(userModelJson));
      Map<String, String> requestBody = {
        'oldPassword': 'oldPassword',
        'newPassword': 'newPassword',
        'confirmPassword': 'newPassword'
      };

      String jsonBody = json.encode(requestBody);

      when(mockClient.post(Uri.parse('$baseUrl/user/userChangePassword'),
              headers: anyNamed('headers'), body: jsonBody))
          .thenAnswer(
        (_) async => http.Response('Too Many Request', 429),
      );

      // Assertion
      expect(
          () async => await profileRemoteDataSourceImple.postChangePassword(
              'oldPassword', 'newPassword', 'newPassword'),
          throwsA(const TypeMatcher<RequestOverloadException>()));
    });
  });
}
