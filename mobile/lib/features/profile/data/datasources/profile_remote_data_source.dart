import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:skill_bridge_mobile/features/features.dart';
import 'package:skill_bridge_mobile/features/profile/data/models/user_profile_model.dart';

import '../../../../core/constants/app_keys.dart';
import '../../../../core/error/exception.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../models/user_leaderboard_model.dart';

abstract class ProfileRemoteDataSource {
  // Future<UserProfile> updateUserProfile(UserProfile profile);
  Future<UserCredentialModel> postChangeUsername(
      String firstname, String lastname);

  Future<ChangePasswordModel> postChangePassword(
      String oldPassword, String newPassword, String repeatPassword);
  Future<UserProfileModel> getUserProfile();
  Future<bool> logout();
  Future<void> clearAuthenticationCredential();
  Future<UserCredentialModel> updateUserAvatar(File imagePath);
  Future<List<UserLeaderboardModel>> getTopUsers();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final http.Client client;

  final FlutterSecureStorage flutterSecureStorage;

  ProfileRemoteDataSourceImpl(
      {required this.client, required this.flutterSecureStorage});

  @override
  Future<UserCredentialModel> updateUserAvatar(File imagePath) async {
    try {
      final userModel = await flutterSecureStorage.read(key: authenticationKey);

      if (userModel == null) {
        throw UnauthorizedRequestException();
      }

      final userModelJson = json.decode(userModel);
      final token = userModelJson['token'];

      Map<String, String> headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': 'Bearer $token',
      };
      var url = Uri.parse('$baseUrl/user/updateProfile');
      var request = http.MultipartRequest('PUT', url);

      request.files.add(http.MultipartFile.fromBytes(
          contentType: MediaType('image', imagePath.path.split(".").last),
          "avatar",
          File(imagePath.path).readAsBytesSync(),
          filename: imagePath.path));

      request.headers.addAll(headers);
      final response = await request.send();

      var res = await http.Response.fromStream(response);

      if (res.statusCode == 200) {
        var data = json.decode(res.body)['data'];

        UserCredentialModel updatedUserCredential =
            UserCredentialModel.fromUpdatedUserJson(data);
        return updatedUserCredential;
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  // get userProfile
  @override
  Future<UserProfileModel> getUserProfile() async {
    final userModel = await flutterSecureStorage.read(key: authenticationKey);

    if (userModel == null) {
      throw UnauthorizedRequestException();
    }

    final userModelJson = json.decode(userModel);
    final token = userModelJson['token'];

    final response = await client.get(
      Uri.parse('$baseUrl/user/currentUser'),
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return UserProfileModel.fromJson(json.decode(response.body)['data']);
    } else {
      throw ServerException();
    }
  }

  // change username
  @override
  Future<UserCredentialModel> postChangeUsername(
      String firstname, String lastname) async {
    final userModel = await flutterSecureStorage.read(key: authenticationKey);

    if (userModel == null) {
      throw UnauthorizedRequestException();
    }

    final userModelJson = json.decode(userModel);
    final token = userModelJson['token'];

    Map<String, String> requestBody = {
      'firstName': firstname,
      'lastName': lastname
    };

    String jsonBody = json.encode(requestBody);

    final response = await http.put(
      Uri.parse('$baseUrl/user/updateProfile'),
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      },
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body)['data'];
      return UserCredentialModel.fromUpdatedUserJson(responseJson);
    } else {
      throw ServerException();
    }
  }

  //change password
  @override
  Future<ChangePasswordModel> postChangePassword(
      String oldPassword, String newPassword, String repeatPassword) async {
    final userModel = await flutterSecureStorage.read(key: authenticationKey);

    if (userModel == null) {
      throw UnauthorizedRequestException();
    }

    final userModelJson = json.decode(userModel);
    final token = userModelJson['token'];

    Map<String, String> requestBody = {
      'oldPassword': oldPassword,
      'newPassword': newPassword,
      'confirmPassword': repeatPassword
    };

    String jsonBody = json.encode(requestBody);

    final response = await http.post(
      Uri.parse('$baseUrl/user/userChangePassword'),
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      },
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      return const ChangePasswordModel();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> clearAuthenticationCredential() async {
    return await flutterSecureStorage.delete(key: authenticationKey);
  }

  @override
  Future<bool> logout() async {
    final userModel = await flutterSecureStorage.read(key: authenticationKey);

    if (userModel == null) {
      throw UnauthorizedRequestException();
    }

    final userModelJson = json.decode(userModel);
    final token = userModelJson['token'];
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/user/logout'),
        headers: {
          'content-Type': 'application/json',
          'authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 201) {
        await clearAuthenticationCredential();
        return true;
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<List<UserLeaderboardModel>> getTopUsers() async {
    final userModel = await flutterSecureStorage.read(key: authenticationKey);

    if (userModel == null) {
      throw UnauthorizedRequestException();
    }

    final userModelJson = json.decode(userModel);
    final token = userModelJson['token'];
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/user/leaderboard'),
        headers: {
          'content-Type': 'application/json',
          'authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        List<dynamic> leaderboard = data['leaderboard'];

        return leaderboard
            .map((item) => UserLeaderboardModel.fromJson(item))
            .toList();
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}
