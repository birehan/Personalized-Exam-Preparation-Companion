import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mockito/annotations.dart';
import 'package:prep_genie/core/core.dart';
import 'package:prep_genie/features/features.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'authentication_repository_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AuthenticationRemoteDatasource>(),
  MockSpec<NetworkInfo>(),
  MockSpec<FlutterSecureStorage>(),
  MockSpec<AuthenticationLocalDatasource>(),
])
void main() {
  late AuthenticationRepositoryImpl repository;
  late MockAuthenticationLocalDatasource mockLocalDatasource;
  late MockAuthenticationRemoteDatasource mockRemoteDatasource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockLocalDatasource = MockAuthenticationLocalDatasource();
    mockRemoteDatasource = MockAuthenticationRemoteDatasource();
    mockNetworkInfo = MockNetworkInfo();
    repository = AuthenticationRepositoryImpl(
      localDatasource: mockLocalDatasource,
      remoteDatasource: mockRemoteDatasource,
      networkInfo: mockNetworkInfo,
    );
  });

  const userCredential = UserCredentialModel(
    id: '1',
    email: 'test@example.com',
    firstName: 'John',
    lastName: 'Doe',
  );

  const email = 'test@example.com';
  const password = 'password123';
  const rememberMe = true;
  const emailOrPhoneNumber = 'test@example.com';
  const String otp = '123456';

  group('getUserCredential', () {
    test('should return user credential from local data source', () async {
      // arrange

      when(mockLocalDatasource.getUserCredential())
          .thenAnswer((_) async => userCredential);
      // act
      final result = await repository.getUserCredential();
      // assert
      expect(result, const Right(userCredential));
      verify(mockLocalDatasource.getUserCredential());
      verifyNoMoreInteractions(mockRemoteDatasource);
    });

    test('should return CacheFailure when an exception occurs', () async {
      // arrange
      when(mockLocalDatasource.getUserCredential()).thenThrow(CacheException());
      // act
      final result = await repository.getUserCredential();
      // assert
      expect(result, Left(CacheFailure()));
      verify(mockLocalDatasource.getUserCredential());
      verifyNoMoreInteractions(mockRemoteDatasource);
    });
  });

  group('login', () {
    test('should return user credential when login is successful', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDatasource.login(
        emailOrPhoneNumber: anyNamed('emailOrPhoneNumber'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => userCredential);

      // Act
      final result = await repository.login(
        emailOrPhoneNumber: emailOrPhoneNumber,
        password: password,
        rememberMe: rememberMe,
      );

      // Assert
      expect(result, const Right(userCredential));
      verify(mockRemoteDatasource.login(
        emailOrPhoneNumber: emailOrPhoneNumber,
        password: password,
      ));
      verify(mockLocalDatasource.cacheAuthenticationCredential(
        userCredentialModel: userCredential,
      ));
      verifyNoMoreInteractions(mockRemoteDatasource);
      verifyNoMoreInteractions(mockLocalDatasource);
    });

    test('should return NetworkFailure when network is disconnected', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // Act
      final result = await repository.login(
        emailOrPhoneNumber: email,
        password: password,
        rememberMe: rememberMe,
      );

      // Assert
      expect(result, Left(NetworkFailure()));
      verifyZeroInteractions(mockRemoteDatasource);
      verifyZeroInteractions(mockLocalDatasource);
    });
  });

  group('resendOtpVerification', () {
    test('should return Unit when resendOtpVerification is successful',
        () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      // Act
      final result = await repository.resendOtpVerification(
        emailOrPhoneNumber: emailOrPhoneNumber,
      );

      // Assert
      expect(result, const Right(unit));
      verify(mockRemoteDatasource.resendOtpVerification(emailOrPhoneNumber));
      verifyNoMoreInteractions(mockRemoteDatasource);
    });

    test('should return NetworkFailure when network is disconnected', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // Act
      final result = await repository.resendOtpVerification(
        emailOrPhoneNumber: emailOrPhoneNumber,
      );

      // Assert
      expect(result, Left(NetworkFailure()));
      verifyZeroInteractions(mockRemoteDatasource);
    });

    test('should return AuthenticationFailure when resendOtpVerification fails',
        () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDatasource.resendOtpVerification(emailOrPhoneNumber))
          .thenThrow(
              AuthenticationException(errorMessage: 'Failed to resend OTP'));

      // Act
      final result = await repository.resendOtpVerification(
        emailOrPhoneNumber: emailOrPhoneNumber,
      );

      // Assert
      expect(result,
          Left(AuthenticationFailure(errorMessage: 'Failed to resend OTP')));
      verify(mockRemoteDatasource.resendOtpVerification(emailOrPhoneNumber));
      verifyNoMoreInteractions(mockRemoteDatasource);
    });
  });

  group('sendOtpVerification', () {
    test('should return Unit when sendOtpVerification is successful', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      // Act
      final result = await repository.sendOtpVerification(
          emailOrPhoneNumber: emailOrPhoneNumber, isForForgotPassword: false);

      // Assert
      expect(result, const Right(unit));
      verify(mockRemoteDatasource.sendOtpVerification(emailOrPhoneNumber, false ));
      verifyNoMoreInteractions(mockRemoteDatasource);
    });

    test('should return NetworkFailure when network is disconnected', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // Act
      final result = await repository.sendOtpVerification(
          emailOrPhoneNumber: emailOrPhoneNumber, isForForgotPassword: false);

      // Assert
      expect(result, Left(NetworkFailure()));
      verifyZeroInteractions(mockRemoteDatasource);
    });

  });

  group('getAppInitialization', () {
    test('should return true when getAppInitialization is successful',
        () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockLocalDatasource.getAppInitialization())
          .thenAnswer((_) async => true);

      // Act
      final result = await repository.getAppInitialization();

      // Assert
      expect(result, const Right(true));
      verify(mockLocalDatasource.getAppInitialization());
      verifyNoMoreInteractions(mockLocalDatasource);
      verifyZeroInteractions(mockRemoteDatasource);
    });

    test('should return false when getAppInitialization is successful',
        () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockLocalDatasource.getAppInitialization())
          .thenAnswer((_) async => false);

      // Act
      final result = await repository.getAppInitialization();

      // Assert
      expect(result, const Right(false));
      verify(mockLocalDatasource.getAppInitialization());
      verifyNoMoreInteractions(mockLocalDatasource);
      verifyZeroInteractions(mockRemoteDatasource);
    });

    test('should return CacheFailure when getAppInitialization fails',
        () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockLocalDatasource.getAppInitialization())
          .thenThrow(CacheException());

      // Act
      final result = await repository.getAppInitialization();

      // Assert
      expect(result, Left(CacheFailure()));
      verify(mockLocalDatasource.getAppInitialization());
      verifyNoMoreInteractions(mockLocalDatasource);
      verifyZeroInteractions(mockRemoteDatasource);
    });
  });

  group('initializeApp', () {
    test('should return Unit when initializeApp is successful', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockLocalDatasource.initializeApp()).thenAnswer((_) async => unit);

      // Act
      final result = await repository.initializeApp();

      // Assert
      expect(result, const Right(unit));
      verify(mockLocalDatasource.initializeApp());
      verifyNoMoreInteractions(mockLocalDatasource);
      verifyZeroInteractions(mockRemoteDatasource);
    });

    test('should return CacheFailure when initializeApp fails', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockLocalDatasource.initializeApp()).thenThrow(CacheException());

      // Act
      final result = await repository.initializeApp();

      // Assert
      expect(result, Left(CacheFailure()));
      verify(mockLocalDatasource.initializeApp());
      verifyNoMoreInteractions(mockLocalDatasource);
      verifyZeroInteractions(mockRemoteDatasource);
    });
  });

  group('changePassword', () {
    const String emailOrPhoneNumber = 'test@example.com';
    const String newPassword = 'newPassword';
    const String confirmPassword = 'newPassword';
    const String otp = '123456';

    test('should return Unit when changePassword is successful', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDatasource.changePassword(
        emailOrPhoneNumber: emailOrPhoneNumber,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
        otp: otp,
      )).thenAnswer((_) async => unit);

      // Act
      final result = await repository.changePassword(
        emailOrPhoneNumber: emailOrPhoneNumber,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
        otp: otp,
      );

      // Assert
      expect(result, const Right(unit));
      verify(mockRemoteDatasource.changePassword(
        emailOrPhoneNumber: emailOrPhoneNumber,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
        otp: otp,
      ));
      verifyNoMoreInteractions(mockRemoteDatasource);
      verifyZeroInteractions(mockLocalDatasource);
    });

    test('should return AuthenticationFailure when changePassword fails',
        () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDatasource.changePassword(
        emailOrPhoneNumber: emailOrPhoneNumber,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
        otp: otp,
      )).thenThrow(AuthenticationException(errorMessage: 'Invalid OTP'));

      // Act
      final result = await repository.changePassword(
        emailOrPhoneNumber: emailOrPhoneNumber,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
        otp: otp,
      );

      // Assert
      expect(result, Left(AuthenticationFailure(errorMessage: 'Invalid OTP')));
      verify(mockRemoteDatasource.changePassword(
        emailOrPhoneNumber: emailOrPhoneNumber,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
        otp: otp,
      ));
      verifyNoMoreInteractions(mockRemoteDatasource);
      verifyZeroInteractions(mockLocalDatasource);
    });

    test('should return NetworkFailure when network is disconnected', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // Act
      final result = await repository.changePassword(
        emailOrPhoneNumber: emailOrPhoneNumber,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
        otp: otp,
      );

      // Assert
      expect(result, Left(NetworkFailure()));
      verifyZeroInteractions(mockRemoteDatasource);
      verifyZeroInteractions(mockLocalDatasource);
    });
  });

  group('forgetPassword', () {
    test('should return Unit when forgetPassword is successful', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDatasource.forgetPassword(
        emailOrPhoneNumber: emailOrPhoneNumber,
        otp: otp,
      )).thenAnswer((_) async => unit);

      // Act
      final result = await repository.forgetPassword(
        emailOrPhoneNumber: emailOrPhoneNumber,
        otp: otp,
      );

      // Assert
      expect(result, const Right(unit));
      verify(mockRemoteDatasource.forgetPassword(
        emailOrPhoneNumber: emailOrPhoneNumber,
        otp: otp,
      ));
      verifyNoMoreInteractions(mockRemoteDatasource);
      verifyZeroInteractions(mockLocalDatasource);
    });

    test('should return AuthenticationFailure when forgetPassword fails',
        () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDatasource.forgetPassword(
        emailOrPhoneNumber: emailOrPhoneNumber,
        otp: otp,
      )).thenThrow(AuthenticationException(errorMessage: 'Invalid OTP'));

      // Act
      final result = await repository.forgetPassword(
        emailOrPhoneNumber: emailOrPhoneNumber,
        otp: otp,
      );

      // Assert
      expect(result, Left(AuthenticationFailure(errorMessage: 'Invalid OTP')));
      verify(mockRemoteDatasource.forgetPassword(
        emailOrPhoneNumber: emailOrPhoneNumber,
        otp: otp,
      ));
      verifyNoMoreInteractions(mockRemoteDatasource);
      verifyZeroInteractions(mockLocalDatasource);
    });

    test('should return NetworkFailure when network is disconnected', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // Act
      final result = await repository.forgetPassword(
        emailOrPhoneNumber: emailOrPhoneNumber,
        otp: otp,
      );

      // Assert
      expect(result, Left(NetworkFailure()));
      verifyZeroInteractions(mockRemoteDatasource);
      verifyZeroInteractions(mockLocalDatasource);
    });
  });
 test('should return NetworkFailure when network is disconnected', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // Act
      final result = await repository.signup(
        emailOrPhoneNumber: 'test@example.com',
        password: 'password123',
        firstName: 'John',
        lastName: 'Doe',
        otp: '123456',
      );

      // Assert
      expect(result, Left(NetworkFailure()));
      verifyZeroInteractions(mockRemoteDatasource);
      verifyZeroInteractions(mockLocalDatasource);
    });}
