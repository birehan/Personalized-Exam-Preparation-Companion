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
  Future<void> storeReferralId({required String referalUserId});
  Future<void> clearRefferalCode();
  Future<String?> getReferralId();
}

class AuthenticationLocalDatasourceImpl extends AuthenticationLocalDatasource {
  final referalCodekey = 'referralId';
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
    try {
      return await flutterSecureStorage.delete(key: authenticationKey);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<bool> getAppInitialization() async {
    try {
      final initialized =
          await flutterSecureStorage.read(key: appInitializationKey);
      if (initialized != null) {
        return true;
      }
      throw CacheException();
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<UserCredentialModel> getUserCredential() async {
    try {
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
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> initializeApp() {
    try {
      return flutterSecureStorage.write(
          key: appInitializationKey, value: 'true');
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> updateUserCredntial(
      {required UserCredentialModel updatedUserCredntialInformation}) async {
    try {
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
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> storeReferralId({required String referalUserId}) async {
    try {
      String? stringfiedJson = json.encode({
        'referralUserId': referalUserId,
      });
      return flutterSecureStorage.write(
        key: referalCodekey,
        value: stringfiedJson,
      );
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<String?> getReferralId() async {
    try {
      final referalCode = await flutterSecureStorage.read(key: referalCodekey);

      if (referalCode != null) {
        return await json.decode(referalCode)['referralUserId'];
      } else {
        throw CacheException();
      }
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> clearRefferalCode() async {
    try {
      return await flutterSecureStorage.delete(key: referalCodekey);
    } catch (e) {
      throw CacheException();
    }
  }
}
