import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' hide UserCredential;
// import 'package:flutter/material.dart';
import '../entities/user_credential.dart';

import '../../../../core/core.dart';

abstract class AuthenticationRepository {
  Future<Either<Failure, UserCredential>> signup({
    required String emailOrPhoneNumber,
    required String password,
    required String firstName,
    required String lastName,
    required String otp,
  });
  Future<Either<Failure, UserCredential>> login({
    required String emailOrPhoneNumber,
    required String password,
    required bool rememberMe,
  });
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, UserCredential>> getUserCredential();
  Future<Either<Failure, Unit>> changePassword({
    required String emailOrPhoneNumber,
    required String newPassword,
    required String confirmPassword,
    required String otp,
  });
  Future<Either<Failure, Unit>> forgetPassword({
    required String emailOrPhoneNumber,
    required String otp,
  });
  Future<Either<Failure, Unit>> sendOtpVerification({
    required String emailOrPhoneNumber,
    required bool isForForgotPassword,
  });
  Future<Either<Failure, Unit>> resendOtpVerification({
    required String emailOrPhoneNumber,
  });
  Future<Either<Failure, Unit>> initializeApp();
  Future<Either<Failure, bool>> getAppInitialization();

  Future<Either<Failure, UserCredential>> signInWithGoogle();
  Future<Either<Failure, Unit>> logoutWithGoogle();
  Future<Either<Failure, bool>> isAuthenticatedWithGoogle();

  // Firestore
  Future<Either<Failure, void>> storeDeviceToken();
  Future<Either<Failure, void>> deleteDeviceToken();
}
