import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:skill_bridge_mobile/core/core.dart';
import 'package:skill_bridge_mobile/features/features.dart';

import 'authentication_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<SignupUsecase>(),
  MockSpec<LoginUsecase>(),
  MockSpec<LogoutUsecase>(),
  MockSpec<ForgetPasswordUsecase>(),
  MockSpec<ChangePasswordUsecase>(),
  MockSpec<SendOtpVerificationUsecase>(),
  MockSpec<ResendOtpVerificationUsecase>(),
  MockSpec<InitializeAppUsecase>(),
  MockSpec<GetAppInitializationUsecase>(),
  MockSpec<SignInWithGoogleUsecase>(),
  MockSpec<SignOutWithGoogleUsecase>(),
  MockSpec<GetSignInWithGoogleUsecase>(),
])
void main() {
  late AuthenticationBloc bloc;
  late SignupUsecase signupUsecase;
  late LoginUsecase loginUsecase;
  late LogoutUsecase logoutUsecase;
  late ForgetPasswordUsecase forgetPasswordUsecase;
  late ChangePasswordUsecase changePasswordUsecase;
  late SendOtpVerificationUsecase sendOtpVerificationUsecase;
  late ResendOtpVerificationUsecase resendOtpVerificationUsecase;
  late InitializeAppUsecase initializeAppUsecase;
  late GetAppInitializationUsecase getAppInitializationUsecase;
  late SignInWithGoogleUsecase signInWithGoogleUsecase;
  late SignOutWithGoogleUsecase signOutWithGoogleUsecase;
  late GetSignInWithGoogleUsecase getSignInWithGoogleUsecase;

  setUp(() {
    signupUsecase = MockSignupUsecase();
    loginUsecase = MockLoginUsecase();
    logoutUsecase = MockLogoutUsecase();
    forgetPasswordUsecase = MockForgetPasswordUsecase();
    changePasswordUsecase = MockChangePasswordUsecase();
    sendOtpVerificationUsecase = MockSendOtpVerificationUsecase();
    resendOtpVerificationUsecase = MockResendOtpVerificationUsecase();
    initializeAppUsecase = MockInitializeAppUsecase();
    getAppInitializationUsecase = MockGetAppInitializationUsecase();
    signInWithGoogleUsecase = MockSignInWithGoogleUsecase();
    signOutWithGoogleUsecase = MockSignOutWithGoogleUsecase();
    getSignInWithGoogleUsecase = MockGetSignInWithGoogleUsecase();

    bloc = AuthenticationBloc(
        changePasswordUsecase: changePasswordUsecase,
        forgetPasswordUsecase: forgetPasswordUsecase,
        getAppInitializationUsecase: getAppInitializationUsecase,
        getSignInWithGoogleUsecase: getSignInWithGoogleUsecase,
        initializeAppUsecase: initializeAppUsecase,
        loginUsecase: loginUsecase,
        logoutUsecase: logoutUsecase,
        resendOtpVerificationUsecase: resendOtpVerificationUsecase,
        sendOtpVerificationUsecase: sendOtpVerificationUsecase,
        signInWithGoogleUsecase: signInWithGoogleUsecase,
        signOutWithGoogleUsecase: signOutWithGoogleUsecase,
        signupUsecase: signupUsecase);
  });
  const validEmail = 'test@example.com';
  const validFirstName = 'John';
  const validLastName = 'Doe';
  const validPassword = 'password123';
  const validOtp = '123456';
  const userCredential = UserCredentialModel(
      id: "1",
      email: validEmail,
      firstName: validFirstName,
      lastName: validLastName);
  const signupParams = SignupParams(
      emailOrPhoneNumber: validEmail,
      firstName: validFirstName,
      lastName: validLastName,
      otp: validOtp,
      password: validPassword);

  group('_onGetDepartmentCourse', () {
    test('should get data from the fetch course videos usecase', () async {
      // arrange
      when(signupUsecase(signupParams))
          .thenAnswer((_) async => const Right(userCredential));
      // act
      bloc.add(const SignupEvent(
          emailOrPhoneNumber: validEmail,
          firstName: validFirstName,
          lastName: validLastName,
          otp: validOtp,
          password: validPassword));

      await untilCalled(signupUsecase(signupParams));
      // assert
      verify(signupUsecase(signupParams));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () {
      // arrange
      when(signupUsecase(signupParams))
          .thenAnswer((_) async => const Right(userCredential));
      // assert later
      final expected = [
        const SignupState(status: AuthStatus.loading),
        const SignupState(status: AuthStatus.loaded)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const SignupEvent(
          emailOrPhoneNumber: validEmail,
          firstName: validFirstName,
          lastName: validLastName,
          otp: validOtp,
          password: validPassword));
    });
    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(signupUsecase(signupParams))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        const SignupState(status: AuthStatus.loading),
        const SignupState(
            status: AuthStatus.error, errorMessage: "Server failure")
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const SignupEvent(
          emailOrPhoneNumber: validEmail,
          firstName: validFirstName,
          lastName: validLastName,
          otp: validOtp,
          password: validPassword));
    });
    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      when(signupUsecase(signupParams))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        const SignupState(status: AuthStatus.loading),
        const SignupState(
            status: AuthStatus.error, errorMessage: "Cache failure")
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const SignupEvent(
          emailOrPhoneNumber: validEmail,
          firstName: validFirstName,
          lastName: validLastName,
          otp: validOtp,
          password: validPassword));
    });
  });

  group('_onLogin', () {
    test('should get data from login usecase and return userCredential',
        () async {
      // arrange
      when(loginUsecase(const LoginParams(
              emailOrPhoneNumber: validEmail,
              password: validPassword,
              rememberMe: true)))
          .thenAnswer((_) async => const Right(userCredential));
      // act
      bloc.add(const LoginEvent(
          emailOrPhoneNumber: validEmail,
          rememberMe: true,
          password: validPassword));

      await untilCalled(loginUsecase(const LoginParams(
          emailOrPhoneNumber: validEmail,
          password: validPassword,
          rememberMe: true)));
      // assert
      verify(loginUsecase(const LoginParams(
          emailOrPhoneNumber: validEmail,
          password: validPassword,
          rememberMe: true)));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () {
      // arrange
      when(loginUsecase(const LoginParams(
              emailOrPhoneNumber: validEmail,
              password: validPassword,
              rememberMe: true)))
          .thenAnswer((_) async => const Right(userCredential));
      // assert later
      final expected = [
        const LoggedInState(status: AuthStatus.loading),
        const LoggedInState(
            status: AuthStatus.loaded, userCredential: userCredential)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const LoginEvent(
          emailOrPhoneNumber: validEmail,
          rememberMe: true,
          password: validPassword));
    });
    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(loginUsecase(const LoginParams(
              emailOrPhoneNumber: validEmail,
              password: validPassword,
              rememberMe: true)))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        const LoggedInState(status: AuthStatus.loading),
        const LoggedInState(
            status: AuthStatus.error, errorMessage: "Server failure")
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const LoginEvent(
          emailOrPhoneNumber: validEmail,
          rememberMe: true,
          password: validPassword));
    });
    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      when(loginUsecase(const LoginParams(
              emailOrPhoneNumber: validEmail,
              password: validPassword,
              rememberMe: true)))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        const LoggedInState(status: AuthStatus.loading),
        const LoggedInState(
            status: AuthStatus.error, errorMessage: "Cache failure")
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const LoginEvent(
          emailOrPhoneNumber: validEmail,
          rememberMe: true,
          password: validPassword));
    });
  });

  group('_onForgetPassword', () {
    test('should get data from forget password usecase ', () async {
      // arrange
      when(forgetPasswordUsecase(const ForgetPasswordParams(
              emailOrPhoneNumber: validEmail, otp: validOtp)))
          .thenAnswer((_) async => const Right(unit));
      // act
      bloc.add(const ForgetPasswordEvent(
          emailOrPhoneNumber: validEmail, otp: validOtp));

      await untilCalled(forgetPasswordUsecase(const ForgetPasswordParams(
          emailOrPhoneNumber: validEmail, otp: validOtp)));
      // assert
      verify(forgetPasswordUsecase(const ForgetPasswordParams(
          emailOrPhoneNumber: validEmail, otp: validOtp)));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () {
      // arrange
      when(forgetPasswordUsecase(const ForgetPasswordParams(
              emailOrPhoneNumber: validEmail, otp: validOtp)))
          .thenAnswer((_) async => const Right(unit));
      // assert later
      final expected = [
        const ForgetPasswordState(status: AuthStatus.loading),
        const ForgetPasswordState(status: AuthStatus.loaded)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const ForgetPasswordEvent(
          emailOrPhoneNumber: validEmail, otp: validOtp));
    });
    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(forgetPasswordUsecase(const ForgetPasswordParams(
              emailOrPhoneNumber: validEmail, otp: validOtp)))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        const ForgetPasswordState(status: AuthStatus.loading),
        const ForgetPasswordState(
            status: AuthStatus.error, errorMessage: "Server failure")
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const ForgetPasswordEvent(
          emailOrPhoneNumber: validEmail, otp: validOtp));
    });
    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      when(forgetPasswordUsecase(const ForgetPasswordParams(
              emailOrPhoneNumber: validEmail, otp: validOtp)))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        const ForgetPasswordState(status: AuthStatus.loading),
        const ForgetPasswordState(
            status: AuthStatus.error, errorMessage: "Cache failure")
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const ForgetPasswordEvent(
          emailOrPhoneNumber: validEmail, otp: validOtp));
    });
  });

  group('_onChangePassword', () {
    test('should get data from change password is called ', () async {
      // arrange
      when(changePasswordUsecase(const ChangePasswordParams(
              confirmPassword: validPassword,
              emailOrPhoneNumber: validEmail,
              newPassword: validPassword,
              otp: validOtp)))
          .thenAnswer((_) async => const Right(unit));
      // act
      bloc.add(const ChangePasswordEvent(
          confirmPassword: validPassword,
          emailOrPhoneNumber: validEmail,
          newPassword: validPassword,
          otp: validOtp));

      await untilCalled(changePasswordUsecase(const ChangePasswordParams(
          confirmPassword: validPassword,
          emailOrPhoneNumber: validEmail,
          newPassword: validPassword,
          otp: validOtp)));
      // assert
      verify(changePasswordUsecase(const ChangePasswordParams(
          confirmPassword: validPassword,
          emailOrPhoneNumber: validEmail,
          newPassword: validPassword,
          otp: validOtp)));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () {
      // arrange
      when(changePasswordUsecase(const ChangePasswordParams(
              confirmPassword: validPassword,
              emailOrPhoneNumber: validEmail,
              newPassword: validPassword,
              otp: validOtp)))
          .thenAnswer((_) async => const Right(unit));
      // assert later
      final expected = [
        const ChangePasswordState(status: AuthStatus.loading),
        const ChangePasswordState(status: AuthStatus.loaded)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const ChangePasswordEvent(
          confirmPassword: validPassword,
          emailOrPhoneNumber: validEmail,
          newPassword: validPassword,
          otp: validOtp));
    });
    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(changePasswordUsecase(const ChangePasswordParams(
              confirmPassword: validPassword,
              emailOrPhoneNumber: validEmail,
              newPassword: validPassword,
              otp: validOtp)))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        const ChangePasswordState(status: AuthStatus.loading),
        const ChangePasswordState(
            status: AuthStatus.error, errorMessage: "Server failure")
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const ChangePasswordEvent(
          confirmPassword: validPassword,
          emailOrPhoneNumber: validEmail,
          newPassword: validPassword,
          otp: validOtp));
    });
    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      when(changePasswordUsecase(const ChangePasswordParams(
              confirmPassword: validPassword,
              emailOrPhoneNumber: validEmail,
              newPassword: validPassword,
              otp: validOtp)))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        const ChangePasswordState(status: AuthStatus.loading),
        const ChangePasswordState(
            status: AuthStatus.error, errorMessage: "Cache failure")
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const ChangePasswordEvent(
          confirmPassword: validPassword,
          emailOrPhoneNumber: validEmail,
          newPassword: validPassword,
          otp: validOtp));
    });
  });

  group('_onSendOtpVerification', () {
    test('should get data from on send otp verification ', () async {
      // arrange
      when(sendOtpVerificationUsecase(
              const SendOtpVerificationParams(emailOrPhoneNumber: validEmail)))
          .thenAnswer((_) async => const Right(unit));
      // act
      bloc.add(const SendOtpVerficationEvent(emailOrPhoneNumber: validEmail));

      await untilCalled(sendOtpVerificationUsecase(
          const SendOtpVerificationParams(emailOrPhoneNumber: validEmail)));
      // assert
      verify(sendOtpVerificationUsecase(
          const SendOtpVerificationParams(emailOrPhoneNumber: validEmail)));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () {
      // arrange
      when(sendOtpVerificationUsecase(
              const SendOtpVerificationParams(emailOrPhoneNumber: validEmail)))
          .thenAnswer((_) async => const Right(unit));
      // assert later
      final expected = [
        const SendOtpVerificationState(status: AuthStatus.loading),
        const SendOtpVerificationState(status: AuthStatus.loaded)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const SendOtpVerficationEvent(emailOrPhoneNumber: validEmail));
    });
    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(sendOtpVerificationUsecase(
              const SendOtpVerificationParams(emailOrPhoneNumber: validEmail)))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        const SendOtpVerificationState(status: AuthStatus.loading),
        const SendOtpVerificationState(
            status: AuthStatus.error, errorMessage: "Server failure")
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const SendOtpVerficationEvent(emailOrPhoneNumber: validEmail));
    });
    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      when(sendOtpVerificationUsecase(
              const SendOtpVerificationParams(emailOrPhoneNumber: validEmail)))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        const SendOtpVerificationState(status: AuthStatus.loading),
        const SendOtpVerificationState(
            status: AuthStatus.error, errorMessage: "Cache failure")
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const SendOtpVerficationEvent(emailOrPhoneNumber: validEmail));
    });
  });

  group('_onResendOtpVerification', () {
    test('should get data from on resend otp verification ', () async {
      // arrange
      when(resendOtpVerificationUsecase(const ResendOtpVerificationParams(
              emailOrPhoneNumber: validEmail)))
          .thenAnswer((_) async => const Right(unit));
      // act
      bloc.add(
          const ResendOtpVerificationEvent(emailOrPhoneNumber: validEmail));

      await untilCalled(resendOtpVerificationUsecase(
          const ResendOtpVerificationParams(emailOrPhoneNumber: validEmail)));
      // assert
      verify(resendOtpVerificationUsecase(
          const ResendOtpVerificationParams(emailOrPhoneNumber: validEmail)));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () {
      // arrange
      when(resendOtpVerificationUsecase(const ResendOtpVerificationParams(
              emailOrPhoneNumber: validEmail)))
          .thenAnswer((_) async => const Right(unit));
      // assert later
      final expected = [
        const ResendOtpVerificationState(status: AuthStatus.loading),
        const SendOtpVerificationState(status: AuthStatus.loaded)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(
          const ResendOtpVerificationEvent(emailOrPhoneNumber: validEmail));
    });
    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(resendOtpVerificationUsecase(const ResendOtpVerificationParams(
              emailOrPhoneNumber: validEmail)))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        const ResendOtpVerificationState(status: AuthStatus.loading),
        const SendOtpVerificationState(
            status: AuthStatus.error, errorMessage: "Server failure")
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(
          const ResendOtpVerificationEvent(emailOrPhoneNumber: validEmail));
    });
    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      when(resendOtpVerificationUsecase(const ResendOtpVerificationParams(
              emailOrPhoneNumber: validEmail)))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        const ResendOtpVerificationState(status: AuthStatus.loading),
        const SendOtpVerificationState(
            status: AuthStatus.error, errorMessage: "Cache failure")
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(
          const ResendOtpVerificationEvent(emailOrPhoneNumber: validEmail));
    });
  });

  group('_onInitializeApp', () {
    test('should get data from on resend otp verification ', () async {
      // arrange
      when(initializeAppUsecase((NoParams())))
          .thenAnswer((_) async => const Right(unit));
      // act
      bloc.add(InitializeAppEvent());

      await untilCalled(initializeAppUsecase((NoParams())));
      // assert
      verify(initializeAppUsecase((NoParams())));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () {
      // arrange
      when(initializeAppUsecase(((NoParams()))))
          .thenAnswer((_) async => const Right(unit));
      // assert later
      final expected = [
        const InitializeAppState(status: AuthStatus.loading),
        const InitializeAppState(status: AuthStatus.loaded)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(InitializeAppEvent());
    });
    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(initializeAppUsecase(NoParams()))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        const InitializeAppState(status: AuthStatus.loading),
        const InitializeAppState(status: AuthStatus.error)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(InitializeAppEvent());
    });
    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      when(initializeAppUsecase(NoParams()))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        const InitializeAppState(status: AuthStatus.loading),
        const InitializeAppState(status: AuthStatus.error)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(InitializeAppEvent());
    });
  });

  group('_onGetAppInitialization', () {
    test('should get data from on get app initialization ', () async {
      // arrange
      when(getAppInitializationUsecase((NoParams())))
          .thenAnswer((_) async => const Right(true));
      // act
      bloc.add(GetAppInitializationEvent());

      await untilCalled(getAppInitializationUsecase((NoParams())));
      // assert
      verify(getAppInitializationUsecase((NoParams())));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () {
      // arrange
      when(getAppInitializationUsecase(((NoParams()))))
          .thenAnswer((_) async => const Right(true));
      // assert later
      final expected = [
        const GetAppInitializationState(status: AuthStatus.loading),
        const GetAppInitializationState(status: AuthStatus.loaded)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(GetAppInitializationEvent());
    });
    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(getAppInitializationUsecase(NoParams()))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        const GetAppInitializationState(status: AuthStatus.loading),
        const GetAppInitializationState(status: AuthStatus.error)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(GetAppInitializationEvent());
    });
    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      when(getAppInitializationUsecase(NoParams()))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        const GetAppInitializationState(status: AuthStatus.loading),
        const GetAppInitializationState(status: AuthStatus.error)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(GetAppInitializationEvent());
    });
  });

  group('_onSignInWithGoogle', () {
    test('should get data from on signin with google', () async {
      // arrange
      when(signInWithGoogleUsecase((NoParams())))
          .thenAnswer((_) async => const Right(userCredential));
      // act
      bloc.add(SignInWithGoogleEvent());

      await untilCalled(signInWithGoogleUsecase((NoParams())));
      // assert
      verify(signInWithGoogleUsecase((NoParams())));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () {
      // arrange
      when(signInWithGoogleUsecase(((NoParams()))))
          .thenAnswer((_) async => const Right(userCredential));
      // assert later
      final expected = [
        const SignInWithGoogleState(status: AuthStatus.loading),
        const SignInWithGoogleState(status: AuthStatus.loaded)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(SignInWithGoogleEvent());
    });
    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(signInWithGoogleUsecase(NoParams()))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        const SignInWithGoogleState(status: AuthStatus.loading),
        const SignInWithGoogleState(status: AuthStatus.error)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(SignInWithGoogleEvent());
    });
    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      when(signInWithGoogleUsecase(NoParams()))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        const SignInWithGoogleState(status: AuthStatus.loading),
        const SignInWithGoogleState(status: AuthStatus.error)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(SignInWithGoogleEvent());
    });
  });

  group('_onSignOutWithGoogle', () {
    test('should get data from on signout in with google', () async {
      // arrange
      when(signOutWithGoogleUsecase((NoParams())))
          .thenAnswer((_) async => const Right(null));
      // act
      bloc.add(SignOutWithGoogleEvent());

      await untilCalled(signOutWithGoogleUsecase((NoParams())));
      // assert
      verify(signOutWithGoogleUsecase((NoParams())));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () {
      // arrange
      when(signOutWithGoogleUsecase(((NoParams()))))
          .thenAnswer((_) async => const Right(null));
      // assert later
      final expected = [
        const SignInWithGoogleState(status: AuthStatus.loading),
        const SignOutWithGoogleState(status: AuthStatus.loaded)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(SignOutWithGoogleEvent());
    });
    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(signOutWithGoogleUsecase(NoParams()))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        const SignInWithGoogleState(status: AuthStatus.loading),
        const SignOutWithGoogleState(status: AuthStatus.error)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(SignOutWithGoogleEvent());
    });
    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      when(signOutWithGoogleUsecase(NoParams()))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        const SignInWithGoogleState(status: AuthStatus.loading),
        const SignOutWithGoogleState(status: AuthStatus.error)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(SignOutWithGoogleEvent());
    });
  });

  group('_onAuthenticatedWithGoogle', () {
    test('should get data from on authenticated in with google', () async {
      // arrange
      when(getSignInWithGoogleUsecase((NoParams())))
          .thenAnswer((_) async => const Right(true));
      // act
      bloc.add(AuthenticatedWithGoogleEvent());

      await untilCalled(getSignInWithGoogleUsecase((NoParams())));
      // assert
      verify(getSignInWithGoogleUsecase((NoParams())));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () {
      // arrange
      when(getSignInWithGoogleUsecase(((NoParams()))))
          .thenAnswer((_) async => const Right(true));
      // assert later
      final expected = [
        const AuthenticatedWithGoogleState(status: AuthStatus.loading),
        const AuthenticatedWithGoogleState(status: AuthStatus.loaded)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(AuthenticatedWithGoogleEvent());
    });
    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(getSignInWithGoogleUsecase(NoParams()))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        const AuthenticatedWithGoogleState(status: AuthStatus.loading),
        const AuthenticatedWithGoogleState(status: AuthStatus.error)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(AuthenticatedWithGoogleEvent());
    });
    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      when(getSignInWithGoogleUsecase(NoParams()))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        const AuthenticatedWithGoogleState(status: AuthStatus.loading),
        const AuthenticatedWithGoogleState(status: AuthStatus.error)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(AuthenticatedWithGoogleEvent());
    });
  });
}
