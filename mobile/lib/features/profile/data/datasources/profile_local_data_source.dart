import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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

  Future<void> logout();
}

class ProfileLocalDataSourceImpl extends ProfileLocalDataSource {
  final FlutterSecureStorage flutterSecureStorage;

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
          profileAvatar: updatedUserCredntialInformation.profileAvatar);
      String? stringfiedJson = json.encode(userCredentialModel);

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
}
