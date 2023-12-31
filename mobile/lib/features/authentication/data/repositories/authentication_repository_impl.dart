import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' hide UserCredential;

// import 'package:flutter/material.dart';

import '../../../../core/core.dart';
import '../../authentication.dart';

class AuthenticationRepositoryImpl extends AuthenticationRepository {
  final AuthenticationLocalDatasource localDatasource;
  final AuthenticationRemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;

  AuthenticationRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserCredential>> getUserCredential() async {
    try {
      final userCredential = await localDatasource.getUserCredential();
      return Right(userCredential);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, UserCredential>> login({
    required String emailOrPhoneNumber,
    required String password,
    required bool rememberMe,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final userCredentialModel = await remoteDatasource.login(
          emailOrPhoneNumber: emailOrPhoneNumber,
          password: password,
        );

        if (rememberMe) {
          await localDatasource.cacheAuthenticationCredential(
            userCredentialModel: userCredentialModel,
          );
        }
        return Right(userCredentialModel);
      } on AuthenticationException catch (e) {
        return Left(AuthenticationFailure(errorMessage: e.errorMessage));
      } on ServerException {
        return Left(ServerFailure());
      } on CacheException {
        return Left(CacheFailure());
      }
    }
    return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, Unit>> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> resendOtpVerification({
    required String emailOrPhoneNumber,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDatasource.resendOtpVerification(emailOrPhoneNumber);
        return const Right(unit);
      } on AuthenticationException catch (e) {
        return Left(AuthenticationFailure(errorMessage: e.errorMessage));
      } on ServerException {
        return Left(ServerFailure());
      }
    }
    return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, Unit>> sendOtpVerification({
    required String emailOrPhoneNumber,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDatasource.sendOtpVerification(emailOrPhoneNumber);
        return const Right(unit);
      } on AuthenticationException catch (e) {
        return Left(AuthenticationFailure(errorMessage: e.errorMessage));
      } on ServerException {
        return Left(ServerFailure());
      }
    }
    return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, bool>> getAppInitialization() async {
    try {
      final isInitialized = await localDatasource.getAppInitialization();
      return Right(isInitialized);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> initializeApp() async {
    try {
      await localDatasource.initializeApp();
      return const Right(unit);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> changePassword({
    required String emailOrPhoneNumber,
    required String newPassword,
    required String confirmPassword,
    required String otp,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDatasource.changePassword(
          emailOrPhoneNumber: emailOrPhoneNumber,
          newPassword: newPassword,
          confirmPassword: confirmPassword,
          otp: otp,
        );
        return const Right(unit);
      } on AuthenticationException catch (e) {
        return Left(AuthenticationFailure(errorMessage: e.errorMessage));
      } on ServerException {
        return Left(ServerFailure());
      }
    }
    return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, Unit>> forgetPassword({
    required String emailOrPhoneNumber,
    required String otp,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDatasource.forgetPassword(
          emailOrPhoneNumber: emailOrPhoneNumber,
          otp: otp,
        );
        return const Right(unit);
      } on AuthenticationException catch (e) {
        return Left(AuthenticationFailure(errorMessage: e.errorMessage));
      } on ServerException {
        return Left(ServerFailure());
      }
    }
    return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, User?>> signInWithGoogle() async {
    if (await networkInfo.isConnected) {
      try {
        final user = await AuthenticationWithGoogle.signInWithGoogle();
        return Right(user);
      } catch (exception) {
        if (exception is SignInWithGoogleException) {
          return Left(
            SignInWithGoogleFailure(
              errorMessage: exception.errorMessage,
            ),
          );
        }
        return Left(SignInWithGoogleFailure(errorMessage: 'Unkown Failure'));
      }
    }
    return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, Unit>> logoutWithGoogle() async {
    if (await networkInfo.isConnected) {
      try {
        await AuthenticationWithGoogle.signOut();
        return const Right(unit);
      } catch (exception) {
        if (exception is SignOutWithGoogleException) {
          return Left(handleSignOutException(exception));
        }
        return Left(SignOutWithGoogleFailure());
      }
    }
    return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, bool>> isAuthenticatedWithGoogle() async {
    if (await networkInfo.isConnected) {
      final isAuthenticatedWithGoogle =
          await AuthenticationWithGoogle.isAuthenticatedWithGoogle();
      return Right(isAuthenticatedWithGoogle);
    }
    return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, UserCredential>> signup({
    required String emailOrPhoneNumber,
    required String password,
    required String firstName,
    required String lastName,
    required String otp,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final userCredentialModel = await remoteDatasource.signup(
          emailOrPhoneNumber: emailOrPhoneNumber,
          password: password,
          firstName: firstName,
          lastName: lastName,
          otp: otp,
        );
        await localDatasource.cacheAuthenticationCredential(
          userCredentialModel: userCredentialModel,
        );
        return Right(userCredentialModel);
      } on AuthenticationException catch (e) {
        return Left(AuthenticationFailure(errorMessage: e.errorMessage));
      } on ServerException {
        return Left(ServerFailure());
      } on CacheException {
        return Left(CacheFailure());
      }
    }
    return Left(NetworkFailure());
  }
}
