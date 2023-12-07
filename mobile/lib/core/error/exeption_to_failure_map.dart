import 'exception.dart';
import 'failure.dart';

Failure mapExceptionToFailure(dynamic e) {
  if (e is ServerException) {
    return ServerFailure();
  } else if (e is UnauthorizedRequestException) {
    return UnauthorizedRequestFailure();
  } else if (e is CacheException) {
    return CacheFailure();
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
