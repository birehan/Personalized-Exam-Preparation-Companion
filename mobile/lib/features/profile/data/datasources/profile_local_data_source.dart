import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:skill_bridge_mobile/core/constants/hive_boxes.dart';
import 'package:skill_bridge_mobile/features/profile/data/models/user_profile_model.dart';
import '../../../features.dart';

import '../../../../core/constants/app_keys.dart';
import '../../../../core/error/exception.dart';

abstract class ProfileLocalDataSource {
  Future<void> updateUserCredentials(UserCredentialModel userCredentialModel);
  Future<UserCredentialModel> getUserCredential();
  // ignore: non_constant_identifier_names
  Future<void> updateUserCredntial({
    required UserCredentialModel updatedUserCredntialInformation,
  });
  Future<void> saveProfileData(dynamic updatedProfile);
  Future<UserProfileModel?> getCachedUserProfile();
  Future<void> logout();
}

class ProfileLocalDataSourceImpl extends ProfileLocalDataSource {
  final FlutterSecureStorage flutterSecureStorage;
  final Box<dynamic> _profileBox = Hive.box(profileBox);
  ProfileLocalDataSourceImpl({required this.flutterSecureStorage});

  @override
  Future<void> updateUserCredentials(UserCredentialModel userCredentialModel) {
    String? stringfiedJson = json.encode(userCredentialModel);
    print(stringfiedJson);
    return flutterSecureStorage.write(
      key: authenticationKey,
      value: stringfiedJson,
    );
  }

  @override
  Future<void> updateUserCredntial(
      {required UserCredentialModel updatedUserCredntialInformation}) async {
    final userCredential =
        await flutterSecureStorage.read(key: authenticationKey);
    if (userCredential != null) {
      UserCredentialModel userCredentialModel = await Future.value(
        UserCredentialModel.fromLocalCachedJson(
          json.decode(userCredential),
        ),
      );

      userCredentialModel = userCredentialModel.copyWith(
        department: updatedUserCredntialInformation.department,
        email: updatedUserCredntialInformation.email,
        departmentId: updatedUserCredntialInformation.departmentId,
        firstName: updatedUserCredntialInformation.firstName,
        lastName: updatedUserCredntialInformation.lastName,
        profileAvatar: updatedUserCredntialInformation.profileAvatar,
        school: updatedUserCredntialInformation.school,
        grade: updatedUserCredntialInformation.grade,
      );

      String? stringfiedJson =
          json.encode(userCredentialModel.toJson(userCredentialModel));
      final aa = stringfiedJson;
      debugPrint(aa, wrapWidth: 1024);
      await flutterSecureStorage.write(
        key: authenticationKey,
        value: stringfiedJson,
      );
    } else {
      throw CacheException();
    }
  }

  @override
  Future<UserCredentialModel> getUserCredential() async {
    final userCredential =
        await flutterSecureStorage.read(key: authenticationKey);
    if (userCredential != null) {
      return Future.value(
        UserCredentialModel.fromLocalCachedJson(
          json.decode(userCredential),
        ),
      );
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> logout() async {
    return await flutterSecureStorage.delete(key: authenticationKey);
  }

  @override
  Future<UserProfileModel?> getCachedUserProfile() async {
    try {
      final userProfile = await _profileBox.get('userProfile');
      if (userProfile != null) {
        final data = json.decode(userProfile);
        return UserProfileModel.fromJson(data['data']);
      }
      return null;
    } catch (e) {
      print(e.toString());
      throw CacheException();
    }
  }

  @override
  Future<void> saveProfileData(dynamic updatedProfile) async {
    try {
      await _profileBox.put('userProfile', updatedProfile);
    } catch (e) {
      print(e.toString());
      throw CacheException();
    }
  }
}
