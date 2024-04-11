import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:prepgenie/core/constants/app_keys.dart';
import 'package:prepgenie/core/utils/hive_boxes.dart';
import 'package:prepgenie/injection_container.dart';

import 'exception.dart';
import 'failure.dart';

final hiveBoxes = serviceLocator<HiveBoxes>();
Future<Failure> mapExceptionToFailure(dynamic e) async {
  const FlutterSecureStorage flutterSecureStorage = FlutterSecureStorage();
  if (e is ServerException) {
    return ServerFailure();
  } else if (e is AuthenticationException) {
    await flutterSecureStorage.delete(key: authenticationKey);
    await hiveBoxes.clearHiveBoxes();

    return AuthenticationFailure(errorMessage: 'Token invalid or expired');
  } else if (e is UnauthorizedRequestException) {
    return UnauthorizedRequestFailure();
  } else if (e is CacheException) {
    return CacheFailure();
  } else if (e is AuthenticationException) {
    return AuthenticationFailure(errorMessage: e.errorMessage);
  } else {
    return AnonymousFailure();
  }
}
//!should it be a class?
// class ExceptionMapper {
//   Failure mapExceptionToFailure(dynamic e) {
//     if (e is ServerException) {
//       return ServerFailure();
//     } else if (e is UnauthorizedRequestException) {
//       return UnauthorizedRequestFailure();
//     } else if (e is CacheException) {
//       return CacheFailure();
//     } else {
//       return AnonymousFailure();
//     }
//   }
// }
//! also this can be implemented 
// Future<Map<String, dynamic>> readToken() async {
//   final userModel = await flutterSecureStorage.read(key: authenticationKey);

//   if (userModel == null) {
//     throw UnauthorizedRequestException();
//   }

//   final userModelJson = json.decode(userModel);
//   return userModelJson;
// }
