import 'dart:convert';
import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../../features.dart';

import '../../../../core/constants/app_keys.dart';
import '../../../../core/error/exception.dart';

abstract class OnboardingQuestionsRemoteDataSource {
  Future<UserCredentialModel> submitOnboardingQuestions(
      OnboardingQuestionsResponse userResponse);
}

class OnboardingQuestionsRemoteDataSourceImpl
    implements OnboardingQuestionsRemoteDataSource {
  final http.Client client;

  final FlutterSecureStorage flutterSecureStorage;

  OnboardingQuestionsRemoteDataSourceImpl({
    required this.client,
    required this.flutterSecureStorage,
  });

  @override
  Future<UserCredentialModel> submitOnboardingQuestions(
      OnboardingQuestionsResponse userResponse) async {
    final userModel = await flutterSecureStorage.read(key: authenticationKey);

    if (userModel == null) {
      throw UnauthorizedRequestException();
    }

    final userModelJson = json.decode(userModel);
    final token = userModelJson['token'];

    final payload = json.encode(
      OnboardingQuestionsModel(
        challengingSubjects: userResponse.challengingSubjects,
        howPrepared: userResponse.howPrepared,
        id: userResponse.id,
        motivation: userResponse.motivation,
        preferedMethod: userResponse.preferedMethod,
        reminderTime: userResponse.reminderTime,
        studyTimePerday: userResponse.studyTimePerday,
        gender: userResponse.gender,
        school: userResponse.school,
        region: userResponse.region,
      ).toJson(),
    );

    try {
     

      final response = await client.put(
        Uri.parse('$baseUrl/user/updateProfile'),
        headers: {
          'content-Type': 'application/json',
          'authorization': 'Bearer $token'
        },
        body: payload,
      );
    
      log(payload);
      if (response.statusCode == 200) {
           print("Hi");
        print("hi");
        var data = json.decode(response.body)['data'];
        print(data);
 print("hello");
      print("heelo");

        UserCredentialModel userCredtial =
            UserCredentialModel.fromUpdatedUserJson(data);

        return userCredtial;
      } else if (response.statusCode == 429) {
         
        throw RequestOverloadException(errorMessage: 'Too Many Request');
      } else {
          print("hello server");
      print("heelo server");
        throw ServerException();
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
