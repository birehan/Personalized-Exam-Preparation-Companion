class ServerException implements Exception {}

class CacheException implements Exception {}

class NetworkConnectionException implements Exception {}

class UnauthorizedRequestException implements Exception {}

class SignInWithGoogleException implements Exception {
  final String errorMessage;

  SignInWithGoogleException({
    required this.errorMessage,
  });
}

class SignOutWithGoogleException implements Exception {
  final String errorMessage;

  SignOutWithGoogleException({
    required this.errorMessage,
  });
}

class CreateQuizException implements Exception {
  CreateQuizException({
    required this.errorMessage,
  });

  final String errorMessage;
}

class AuthenticationException implements Exception {
  AuthenticationException({
    required this.errorMessage,
  });

  final String errorMessage;
}
