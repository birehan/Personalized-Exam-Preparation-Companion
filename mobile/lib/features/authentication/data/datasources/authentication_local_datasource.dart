import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../features.dart';

import '../../../../core/constants/app_keys.dart';
import '../../../../core/core.dart';
import '../data.dart';

abstract class AuthenticationLocalDatasource {
  Future<void> cacheAuthenticationCredential({
    required UserCredentialModel userCredentialModel,
  });
  Future<UserCredentialModel> getUserCredential();
  Future<void> clearAuthenticationCredential();
  Future<void> initializeApp();
  Future<bool> getAppInitialization();
  Future<void> updateUserCredntial({
    required UserCredentialModel updatedUserCredntialInformation,
  });
}

class AuthenticationLocalDatasourceImpl extends AuthenticationLocalDatasource {
  final FlutterSecureStorage flutterSecureStorage;

  AuthenticationLocalDatasourceImpl({
    required this.flutterSecureStorage,
  });

  @override
  Future<void> cacheAuthenticationCredential({
    required UserCredentialModel userCredentialModel,
  }) {
    String? stringfiedJson = json.encode(
      userCredentialModel.toJson(
        userCredentialModel,
      ),
    );
    final profileAvatar = json.decode(stringfiedJson);
    return flutterSecureStorage.write(
      key: authenticationKey,
      value: stringfiedJson,
    );
  }

  @override
  Future<void> clearAuthenticationCredential() async {
    return await flutterSecureStorage.delete(key: authenticationKey);
  }

  @override
  Future<bool> getAppInitialization() async {
    final initialized =
        await flutterSecureStorage.read(key: appInitializationKey);
    if (initialized != null) {
      return true;
    }
    throw CacheException();
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
  Future<void> initializeApp() {
    return flutterSecureStorage.write(key: appInitializationKey, value: 'true');
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
        departmentId: updatedUserCredntialInformation.departmentId,
      );
      String? stringfiedJson =
          json.encode(userCredentialModel.toJson(userCredentialModel));

      await flutterSecureStorage.write(
        key: authenticationKey,
        value: stringfiedJson,
      );
    } else {
      throw CacheException();
    }
  }
}
