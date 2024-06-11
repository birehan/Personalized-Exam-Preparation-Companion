import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/core.dart';

import '../../../../core/constants/app_keys.dart';
import '../../authentication.dart';

import 'package:http/http.dart' as http;

abstract class AuthenticationRemoteDatasource {
  Future<UserCredentialModel> signup({
    required String emailOrPhoneNumber,
    required String password,
    required String firstName,
    required String lastName,
    required String otp,
    String? refferalId,
  });
  Future<UserCredentialModel> login({
    required String emailOrPhoneNumber,
    required String password,
  });
  Future<void> logout();
  Future<void> forgetPassword({
    required String emailOrPhoneNumber,
    required String otp,
  });
  Future<void> changePassword({
    required String emailOrPhoneNumber,
    required String newPassword,
    required String confirmPassword,
    required String otp,
  });
  Future<void> sendOtpVerification(
      String emailOrPhoneNumber, bool isForForgotPassword);
  Future<void> resendOtpVerification(String emailOrPhoneNumber);
  Future<UserCredentialModel> getUser();

  Future<void> storeDeviceToken();
  Future<void> deleteDeviceToken();
  Future<UserCredentialModel> signInWithGoogle({required String idToken});
}

class AuthenticationRemoteDatasourceImpl
    extends AuthenticationRemoteDatasource {
  final http.Client client;

  AuthenticationRemoteDatasourceImpl({
    required this.client,
  });

  @override
  Future<UserCredentialModel> getUser() async {
    throw UnimplementedError();
  }

  @override
  Future<UserCredentialModel> login(
      {required String emailOrPhoneNumber, required String password}) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/user/login'),
        body: json.encode({
          'email_phone': emailOrPhoneNumber,
          'password': password,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseJson = json.decode(response.body)['data'];
        print(responseJson);
        return UserCredentialModel.fromJson(responseJson);
      } else if (response.statusCode == 429) {
        throw RequestOverloadException(errorMessage: 'Too Many Request');
      } else {
        final errorMessage = json.decode(response.body)['message'];
        throw AuthenticationException(
          errorMessage: errorMessage,
        );
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  Future<void> logout() {
    throw UnimplementedError();
  }

  @override
  Future<void> resendOtpVerification(String emailOrPhoneNumber) async {
    final response = await client.post(
      Uri.parse('$baseUrl/user/reSendOTPCode'),
      body: json.encode({
        'email_phone': emailOrPhoneNumber,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 201) {
      return;
    } else if (response.statusCode == 429) {
      throw RequestOverloadException(errorMessage: 'Too Many Request');
    }
    final errorMessage = json.decode(response.body)['message'];
    throw AuthenticationException(errorMessage: errorMessage);
  }

  @override
  Future<void> sendOtpVerification(
      String emailOrPhoneNumber, bool isForForgotPassword) async {
    final url = isForForgotPassword
        ? '$baseUrl/user/sendOTPCodeForgotPass'
        : '$baseUrl/user/sendOTPCode';
    
 
    final response = await client.post(
      Uri.parse(url),
      body: json.encode({
        'email_phone': emailOrPhoneNumber,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 201) {
      return;
    } else if (response.statusCode == 429) {
      throw RequestOverloadException(errorMessage: 'Too Many Request');
    }
    final errorMessage = json.decode(response.body)['message'];
    throw AuthenticationException(errorMessage: errorMessage);
  }

  @override
  Future<UserCredentialModel> signup({
    required String emailOrPhoneNumber,
    required String password,
    required String firstName,
    required String lastName,
    required String otp,
    String? refferalId,
  }) async {

       print("hi");
    print("hi");

  print('$baseUrl/user/signup');
  print("hi");
print({
        'email_phone': emailOrPhoneNumber,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'otp': otp,
        'referredBy': refferalId,
      });
  print("hi");

    final response = await client.post(
      Uri.parse('$baseUrl/user/signup'),
      body: json.encode({
        'email_phone': emailOrPhoneNumber,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'otp': otp,
        'referredBy': refferalId,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 201) {
      final responseJson = json.decode(response.body)['data'];

      return UserCredentialModel.fromJson(responseJson);
    } else if (response.statusCode == 429) {
      throw RequestOverloadException(errorMessage: 'Too Many Request');
    }
    final errorMessage = json.decode(response.body)['message'];
    throw AuthenticationException(errorMessage: errorMessage);
  }

  @override
  Future<void> changePassword({
    required String emailOrPhoneNumber,
    required String newPassword,
    required String confirmPassword,
    required String otp,
  }) async {
    final response = await client.post(
      Uri.parse('$baseUrl/user/forgotChangePassword'),
      body: json.encode({
        'email_phone': emailOrPhoneNumber,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
        'otp': otp,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 429) {
      throw RequestOverloadException(errorMessage: 'Too Many Request');
    }
    final errorMessage = json.decode(response.body)['message'];
    throw AuthenticationException(errorMessage: errorMessage);
  }

  @override
  Future<void> forgetPassword({
    required String emailOrPhoneNumber,
    required String otp,
  }) async {
    final response = await client.post(
      Uri.parse('$baseUrl/user/forgotPassVerifyOTP'),
      body: json.encode({
        'email_phone': emailOrPhoneNumber,
        'otp': otp,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 429) {
      throw RequestOverloadException(errorMessage: 'Too Many Request');
    }
    final errorMessage = json.decode(response.body)['message'];
    throw AuthenticationException(errorMessage: errorMessage);
  }

  @override
  Future<void> deleteDeviceToken() async {
    try {
      final userCredential = await AuthenticationLocalDatasourceImpl(
        flutterSecureStorage: GetIt.instance.get<FlutterSecureStorage>(),
      ).getUserCredential();

      final userId = userCredential.id;
      final usersDeviceTokenCollection = "";

      return await FirebaseFirestore.instance
          .collection(usersDeviceTokenCollection)
          .doc(userId)
          .delete();
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> storeDeviceToken() async {
    try {
      final userCredential = await AuthenticationLocalDatasourceImpl(
        flutterSecureStorage: GetIt.instance.get<FlutterSecureStorage>(),
      ).getUserCredential();

      final userId = userCredential.id;

      final deviceToken = await NotificationService().getToken();

      if (deviceToken == null) {
        throw DeviceTokenNotFoundException();
      }

      final usersDeviceTokenCollection = "";

      return await FirebaseFirestore.instance
          .collection(usersDeviceTokenCollection)
          .doc(userId)
          .set(
        {
          "user_id": userId,
          "device_token": deviceToken,
        },
      );
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<UserCredentialModel> signInWithGoogle(
      {required String idToken}) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/user/googleSingIn'),
        body: json.encode({
          "idToken": idToken,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 201) {
        final responseJson = json.decode(response.body)['data'];
        return UserCredentialModel.fromJson(responseJson);
      }
      final errorMessage = json.decode(response.body)['message'];
      throw AuthenticationException(errorMessage: errorMessage);
    } catch (e) {
      rethrow;
    }
  }
}