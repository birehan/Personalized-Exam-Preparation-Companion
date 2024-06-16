import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:prep_genie/core/constants/app_keys.dart';
import 'package:prep_genie/core/error/exception.dart';
import 'package:prep_genie/features/authentication/authentication.dart';

import '../../../../fixtures/fixture_reader.dart';
// import '../../../contest/data/datasources/contest_remote_datasources_test.mocks.dart'
//     hide MockFlutterSecureStorage;
import '../../../course/data/datasources/course_remote_datasource_test.mocks.dart';

void main() {
  late AuthenticationRemoteDatasource remoteDatasource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    remoteDatasource = AuthenticationRemoteDatasourceImpl(
      client: mockHttpClient,
    );
  });

  const userCredentialModel = UserCredentialModel(
    id: '64ee629398e23256a5ece781',
    email: 'test@gmail.com',
    firstName: 'test',
    lastName: 'test',
    token:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6eyJlbWFpbCI6InRlc2ZheWVmb3Jkb3dubG9hZDExMjJAZ21haWwuY29tIiwiZmlyc3ROYW1lIjoiRGFuaWVsIiwibGFzdE5hbWUiOiJUZWZlcmEiLCJwYXNzd29yZCI6IiQyYiQxMCRneEdzMUtxRzh2Mzh1czdaR1FVR2RlNUlkenBwb3IyRWx0M2dFc1pSRGZWNFRMQTEyQUNlYSIsImRlcGFydG1lbnQiOm51bGwsImF2YXRhciI6bnVsbCwicmVzZXRUb2tlbiI6IiIsImhvd1ByZXBhcmVkIjoiIiwicHJlZmVycmVkTWV0aG9kIjoiIiwic3R1ZHlUaW1lUGVyRGF5IjoiIiwibW90aXZhdGlvbiI6IiIsImNoYWxsZW5naW5nU3ViamVjdHMiOltdLCJyZW1pbmRlciI6IiIsIl9pZCI6IjY0ZWU2MjkzOThlMjMyNTZhNWVjZTc4MSIsImNyZWF0ZWRBdCI6IjIwMjMtMDgtMjlUMjE6MjY6NDMuOTY0WiIsInVwZGF0ZWRBdCI6IjIwMjMtMDgtMjlUMjE6MjY6NDMuOTY0WiIsIl9fdiI6MH0sImlhdCI6MTY5MzM0NDQwNCwiZXhwIjoxNjk1OTM2NDA0fQ.32P0hhoJQ7o8eDGcwoO8o6Wny1nXxVubDOj2UkdL_yQ',
  );

  group('signup', () {
    test(
        'should perform a post request on a URL being the endpoint and with application/json header',
        () async {
      // arrange
      when(mockHttpClient.post(
        Uri.parse('$baseUrl/user/signup'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async =>
          http.Response(fixture('authentication/signup.json'), 201));
      // act
      await remoteDatasource.signup(
        emailOrPhoneNumber: 'test@gmail.com',
        password: 'password',
        firstName: 'test',
        lastName: 'test',
        otp: '123456',
      );
      // assert
      verify(mockHttpClient.post(
        Uri.parse('$baseUrl/user/signup'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      ));
    });

    test(
        'should return UserCredentialModel when the response code is 201 (success)',
        () async {
      // arrange

      when(mockHttpClient.post(
        Uri.parse('$baseUrl/user/signup'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async =>
          http.Response(fixture('authentication/signup.json'), 201));
      // act
      final result = await remoteDatasource.signup(
        emailOrPhoneNumber: 'test@gmail.com',
        password: 'password',
        firstName: 'test',
        lastName: 'test',
        otp: '123456',
      );
      // assert
      expect(result, equals(userCredentialModel));
    });

    test(
        'should throw a RequestOverloadException when the response code is 429',
        () async {
      // arrange
      when(mockHttpClient.post(
        Uri.parse('$baseUrl/user/signup'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async =>
          http.Response(json.encode({'message': 'Something went wrong'}), 429));
      // act
      final call = remoteDatasource.signup;
      // assert
      expect(
          () async => await call(
                emailOrPhoneNumber: 'test@gmail.com',
                password: 'password',
                firstName: 'test',
                lastName: 'test',
                otp: '123456',
              ),
          throwsA(const TypeMatcher<RequestOverloadException>()));
    });

    test(
        'should throw a AuthenticationException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.post(
        Uri.parse('$baseUrl/user/signup'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async =>
          http.Response(json.encode({'message': 'Something went wrong'}), 404));
      // act
      final call = remoteDatasource.signup;
      // assert
      expect(
          () async => await call(
                emailOrPhoneNumber: 'test@gmail.com',
                password: 'password',
                firstName: 'test',
                lastName: 'test',
                otp: '123456',
              ),
          throwsA(const TypeMatcher<AuthenticationException>()));
    });

    group('login', () {
      test(
          'should perform a post request on a URL being the endpoint and with application/json header',
          () async {
        // arrange
        when(mockHttpClient.post(
          Uri.parse('$baseUrl/user/login'),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async =>
            http.Response(fixture('authentication/signup.json'), 200));
        // act
        await remoteDatasource.login(
          emailOrPhoneNumber: 'test@gmail.com',
          password: 'password',
        );
        // assert
        verify(mockHttpClient.post(
          Uri.parse('$baseUrl/user/login'),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ));
      });

      test(
          'should return UserCredentialModel when the response code is 201 (success)',
          () async {
        // arrange

        when(mockHttpClient.post(
          Uri.parse('$baseUrl/user/login'),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async =>
            http.Response(fixture('authentication/signup.json'), 200));
        // act
        final result = await remoteDatasource.login(
          emailOrPhoneNumber: 'test@gmail.com',
          password: 'password',
        );
        // assert
        expect(result, equals(userCredentialModel));
      });

      test(
          'should throw a RequestOverloadException when the response code is 429',
          () async {
        // arrange
        when(mockHttpClient.post(
          Uri.parse('$baseUrl/user/login'),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response(
            json.encode({'message': 'Something went wrong'}), 429));
        // act
        final call = remoteDatasource.login;
        // assert
        expect(
            () async => await call(
                  emailOrPhoneNumber: 'test@gmail.com',
                  password: 'password',
                ),
            throwsA(const TypeMatcher<RequestOverloadException>()));
      });

      test(
          'should throw a AuthenticationException when the response code is 404 or other',
          () async {
        // arrange
        when(mockHttpClient.post(
          Uri.parse('$baseUrl/user/login'),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response(
            json.encode({'message': 'Something went wrong'}), 404));
        // act
        final call = remoteDatasource.login;
        // assert
        expect(
            () async => await call(
                  emailOrPhoneNumber: 'test@gmail.com',
                  password: 'password',
                ),
            throwsA(const TypeMatcher<AuthenticationException>()));
      });
    });

    group('resendOtpVerification', () {
      test(
          'should perform a post request on a URL being the endpoint and with application/json header',
          () async {
        // arrange
        when(mockHttpClient.post(
          Uri.parse('$baseUrl/user/reSendOTPCode'),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response('true', 201));
        // act
        await remoteDatasource.resendOtpVerification(
          'test@gmail.com',
        );
        // assert
        verify(mockHttpClient.post(
          Uri.parse('$baseUrl/user/reSendOTPCode'),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ));
      });

      test(
          'should throw a AuthenticationException when the response code is 404 or other',
          () async {
        // arrange
        when(mockHttpClient.post(
          Uri.parse('$baseUrl/user/reSendOTPCode'),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response(
            json.encode({'message': 'Something went wrong'}), 404));
        // act
        final call = remoteDatasource.resendOtpVerification;
        // assert
        expect(
            () async => await call(
                  'test@gmail.com',
                ),
            throwsA(const TypeMatcher<AuthenticationException>()));
      });
    });

    group('changePassword', () {
      test(
          'should perform a post request on a URL being the endpoint and with application/json header',
          () async {
        // arrange
        when(mockHttpClient.post(
          Uri.parse('$baseUrl/user/forgotChangePassword'),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response('true', 200));
        // act
        await remoteDatasource.changePassword(
          emailOrPhoneNumber: 'test@gmail.com',
          newPassword: 'password',
          confirmPassword: 'password',
          otp: '123456',
        );
        // assert
        verify(mockHttpClient.post(
          Uri.parse('$baseUrl/user/forgotChangePassword'),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ));
      });

      test(
          'should throw a RequesOverloadException when the response code is 429',
          () async {
        // arrange
        when(mockHttpClient.post(
          Uri.parse('$baseUrl/user/forgotChangePassword'),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response(
            json.encode({'message': 'Something went wrong'}), 429));
        // act
        final call = remoteDatasource.changePassword;
        // assert
        expect(
            () async => await call(
                  emailOrPhoneNumber: 'test@gmail.com',
                  newPassword: 'password',
                  confirmPassword: 'password',
                  otp: '123456',
                ),
            throwsA(const TypeMatcher<RequestOverloadException>()));
      });
      test(
          'should throw a AuthenticationException when the response code is 404 or other',
          () async {
        // arrange
        when(mockHttpClient.post(
          Uri.parse('$baseUrl/user/forgotChangePassword'),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response(
            json.encode({'message': 'Something went wrong'}), 404));
        // act
        final call = remoteDatasource.changePassword;
        // assert
        expect(
            () async => await call(
                  emailOrPhoneNumber: 'test@gmail.com',
                  newPassword: 'password',
                  confirmPassword: 'password',
                  otp: '123456',
                ),
            throwsA(const TypeMatcher<AuthenticationException>()));
      });
    });

    group('forgetPassword', () {
      test(
          'should perform a post request on a URL being the endpoint and with application/json header',
          () async {
        // arrange
        when(mockHttpClient.post(
          Uri.parse('$baseUrl/user/forgotPassVerifyOTP'),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response('true', 200));
        // act
        await remoteDatasource.forgetPassword(
          emailOrPhoneNumber: 'test@gmail.com',
          otp: '123456',
        );
        // assert
        verify(mockHttpClient.post(
          Uri.parse('$baseUrl/user/forgotPassVerifyOTP'),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        ));
      });

      test(
          'should throw a RequestOverloadException when the response code is 429 or other',
          () async {
        // arrange
        when(mockHttpClient.post(
          Uri.parse('$baseUrl/user/forgotPassVerifyOTP'),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response(
            json.encode({'message': 'Something went wrong'}), 429));
        // act
        final call = remoteDatasource.forgetPassword;
        // assert
        expect(
            () async => await call(
                  emailOrPhoneNumber: 'test@gmail.com',
                  otp: '123456',
                ),
            throwsA(const TypeMatcher<RequestOverloadException>()));
      });
      test(
          'should throw a AuthenticationException when the response code is 404 or other',
          () async {
        // arrange
        when(mockHttpClient.post(
          Uri.parse('$baseUrl/user/forgotPassVerifyOTP'),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response(
            json.encode({'message': 'Something went wrong'}), 404));
        // act
        final call = remoteDatasource.forgetPassword;
        // assert
        expect(
            () async => await call(
                  emailOrPhoneNumber: 'test@gmail.com',
                  otp: '123456',
                ),
            throwsA(const TypeMatcher<AuthenticationException>()));
      });
    });
  });
}
