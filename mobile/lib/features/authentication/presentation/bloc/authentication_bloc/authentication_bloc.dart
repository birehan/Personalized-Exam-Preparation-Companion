import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' hide UserCredential;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/core.dart';
import '../../../authentication.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final SignupUsecase signupUsecase;
  final LoginUsecase loginUsecase;
  final LogoutUsecase logoutUsecase;
  final ForgetPasswordUsecase forgetPasswordUsecase;
  final ChangePasswordUsecase changePasswordUsecase;
  final SendOtpVerificationUsecase sendOtpVerificationUsecase;
  final ResendOtpVerificationUsecase resendOtpVerificationUsecase;
  final InitializeAppUsecase initializeAppUsecase;
  final GetAppInitializationUsecase getAppInitializationUsecase;
  final SignInWithGoogleUsecase signInWithGoogleUsecase;
  final SignOutWithGoogleUsecase signOutWithGoogleUsecase;
  final GetSignInWithGoogleUsecase getSignInWithGoogleUsecase;

  AuthenticationBloc({
    required this.signupUsecase,
    required this.loginUsecase,
    required this.logoutUsecase,
    required this.forgetPasswordUsecase,
    required this.changePasswordUsecase,
    required this.sendOtpVerificationUsecase,
    required this.resendOtpVerificationUsecase,
    required this.initializeAppUsecase,
    required this.getAppInitializationUsecase,
    required this.signInWithGoogleUsecase,
    required this.signOutWithGoogleUsecase,
    required this.getSignInWithGoogleUsecase,
  }) : super(AuthenticationInitial()) {
    on<SignupEvent>(_onSignup);
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
    on<ForgetPasswordEvent>(_onForgetPassword);
    on<ChangePasswordEvent>(_onChangePassword);
    on<SendOtpVerficationEvent>(_onSendOtpVerification);
    on<ResendOtpVerificationEvent>(_onResendOtpVerification);
    on<InitializeAppEvent>(_onInitializeApp);
    on<GetAppInitializationEvent>(_onGetAppInitialization);
    on<SignInWithGoogleEvent>(_onSignInWithGoogle);
    on<SignOutWithGoogleEvent>(_onSignOutWithGoogle);
    on<AuthenticatedWithGoogleEvent>(_onAuthenticatedWithGoogle);
  }

  void _onSignup(SignupEvent event, Emitter<AuthenticationState> emit) async {
    emit(const SignupState(status: AuthStatus.loading));
    String? phoneNumber;

    if (validatePhoneNumber(event.emailOrPhoneNumber) == null) {
      phoneNumber = phoneNumberConverter(event.emailOrPhoneNumber);
    }

    final failureOrSignup = await signupUsecase(
      SignupParams(
        emailOrPhoneNumber: phoneNumber ?? event.emailOrPhoneNumber,
        password: event.password,
        firstName: event.firstName,
        lastName: event.lastName,
        otp: event.otp,
      ),
    );
    emit(_eitherSignupOrFailure(failureOrSignup));
  }

  AuthenticationState _eitherSignupOrFailure(
      Either<Failure, void> failureOrSignup) {
    return failureOrSignup.fold(
      (l) =>
          SignupState(status: AuthStatus.error, errorMessage: l.errorMessage),
      (r) => const SignupState(status: AuthStatus.loaded),
    );
  }

  void _onLogin(LoginEvent event, Emitter<AuthenticationState> emit) async {
    emit(const LoggedInState(status: AuthStatus.loading));
    String? phoneNumber;

    if (validatePhoneNumber(event.emailOrPhoneNumber) == null) {
      phoneNumber = phoneNumberConverter(event.emailOrPhoneNumber);
    }

    final failureOrUserCredential = await loginUsecase(
      LoginParams(
        emailOrPhoneNumber: phoneNumber ?? event.emailOrPhoneNumber,
        password: event.password,
        rememberMe: event.rememberMe,
      ),
    );
    emit(_eitherLoginOrError(failureOrUserCredential));
  }

  AuthenticationState _eitherLoginOrError(
      Either<Failure, UserCredential> failureOrUserCredential) {
    return failureOrUserCredential.fold(
      (failure) => LoggedInState(
        status: AuthStatus.error,
        errorMessage: failure.errorMessage,
      ),
      (userCredential) => LoggedInState(
        status: AuthStatus.loaded,
        userCredential: userCredential,
      ),
    );
  }

  // String _mapLoginFailureToMessage(Failure failure) {
  //   switch (failure.runtimeType) {
  //     case ServerFailure:
  //       return loginFailureMessage;
  //     case NetworkFailure:
  //       return networkFailureMessage;
  //     case CacheFailure:
  //       return loginCacheFailureMessage;
  //     default:
  //       return unknownFailureMessage;
  //   }
  // }

  void _onLogout(LogoutEvent event, Emitter<AuthenticationState> emit) async {}

  void _onForgetPassword(
      ForgetPasswordEvent event, Emitter<AuthenticationState> emit) async {
    emit(const ForgetPasswordState(status: AuthStatus.loading));

    String? phoneNumber;

    if (validatePhoneNumber(event.emailOrPhoneNumber) == null) {
      phoneNumber = phoneNumberConverter(event.emailOrPhoneNumber);
    }

    final failureOrForgotPassword = await forgetPasswordUsecase(
      ForgetPasswordParams(
        emailOrPhoneNumber: phoneNumber ?? event.emailOrPhoneNumber,
        otp: event.otp,
      ),
    );
    emit(_eitherForgotPasswordOrError(failureOrForgotPassword));
  }

  AuthenticationState _eitherForgotPasswordOrError(
      Either<Failure, void> failureOrForgotPassword) {
    return failureOrForgotPassword.fold(
      (failure) => ForgetPasswordState(
        status: AuthStatus.error,
        errorMessage: failure.errorMessage,
      ),
      (_) => const ForgetPasswordState(
        status: AuthStatus.loaded,
      ),
    );
  }

  void _onChangePassword(
      ChangePasswordEvent event, Emitter<AuthenticationState> emit) async {
    emit(const ChangePasswordState(status: AuthStatus.loading));

    String? phoneNumber;

    if (validatePhoneNumber(event.emailOrPhoneNumber) == null) {
      phoneNumber = phoneNumberConverter(event.emailOrPhoneNumber);
    }

    final failureOrChangePassword = await changePasswordUsecase(
      ChangePasswordParams(
        emailOrPhoneNumber: phoneNumber ?? event.emailOrPhoneNumber,
        newPassword: event.newPassword,
        confirmPassword: event.confirmPassword,
        otp: event.otp,
      ),
    );
    emit(_eitherChangePasswordOrError(failureOrChangePassword));
  }

  AuthenticationState _eitherChangePasswordOrError(
      Either<Failure, void> failureOrChangePassword) {
    return failureOrChangePassword.fold(
      (failure) => ChangePasswordState(
        status: AuthStatus.error,
        errorMessage: failure.errorMessage,
      ),
      (_) => const ChangePasswordState(
        status: AuthStatus.loaded,
      ),
    );
  }

  void _onSendOtpVerification(
      SendOtpVerficationEvent event, Emitter<AuthenticationState> emit) async {
    emit(const SendOtpVerificationState(status: AuthStatus.loading));

    String? phoneNumber;

    if (validatePhoneNumber(event.emailOrPhoneNumber) == null) {
      phoneNumber = phoneNumberConverter(event.emailOrPhoneNumber);
    }

    final failureOrOtp =
        await sendOtpVerificationUsecase(SendOtpVerificationParams(
      emailOrPhoneNumber: phoneNumber ?? event.emailOrPhoneNumber,
    ));
    emit(_eitherOtpOrError(failureOrOtp));
  }

  AuthenticationState _eitherOtpOrError(Either<Failure, void> failureOrOtp) {
    return failureOrOtp.fold(
      (failure) => SendOtpVerificationState(
        status: AuthStatus.error,
        errorMessage: failure.errorMessage,
      ),
      (success) => const SendOtpVerificationState(status: AuthStatus.loaded),
    );
  }

  // String _mapSignupFailureToMessage(Failure failure) {
  //   switch (failure.runtimeType) {
  //     case ServerFailure:
  //       return signupFailureMessage;
  //     case CacheFailure:
  //       return signupCacheFailureMessage;
  //     case NetworkFailure:
  //       return networkFailureMessage;
  //     default:
  //       return unknownFailureMessage;
  //   }
  // }

  void _onResendOtpVerification(
    ResendOtpVerificationEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(const ResendOtpVerificationState(status: AuthStatus.loading));

    String? phoneNumber;

    if (validatePhoneNumber(event.emailOrPhoneNumber) == null) {
      phoneNumber = phoneNumberConverter(event.emailOrPhoneNumber);
    }

    final failureOrOtp = await resendOtpVerificationUsecase(
      ResendOtpVerificationParams(
        emailOrPhoneNumber: phoneNumber ?? event.emailOrPhoneNumber,
      ),
    );
    emit(_eitherOtpOrError(failureOrOtp));
  }

  void _onInitializeApp(
      InitializeAppEvent event, Emitter<AuthenticationState> emit) async {
    emit(const InitializeAppState(status: AuthStatus.loading));
    final failureOrInitializeApp = await initializeAppUsecase(NoParams());
    emit(_eitherInitializeAppOrError(failureOrInitializeApp));
  }

  AuthenticationState _eitherInitializeAppOrError(
      Either<Failure, void> failureOrInitializeApp) {
    return failureOrInitializeApp.fold(
      (l) => const InitializeAppState(status: AuthStatus.error),
      (r) => const InitializeAppState(status: AuthStatus.loaded),
    );
  }

  void _onGetAppInitialization(GetAppInitializationEvent event,
      Emitter<AuthenticationState> emit) async {
    emit(const GetAppInitializationState(status: AuthStatus.loading));
    final failureOrGetAppInitialization =
        await getAppInitializationUsecase(NoParams());
    emit(_eitherGetAppInitializationOrError(failureOrGetAppInitialization));
  }

  AuthenticationState _eitherGetAppInitializationOrError(
      Either<Failure, void> failureOrGetAppInitialization) {
    return failureOrGetAppInitialization.fold(
      (l) => const GetAppInitializationState(status: AuthStatus.error),
      (r) => const GetAppInitializationState(status: AuthStatus.loaded),
    );
  }

  void _onSignInWithGoogle(
      SignInWithGoogleEvent event, Emitter<AuthenticationState> emit) async {
    emit(const SignInWithGoogleState(status: AuthStatus.loading));
    final failureOrSignOutWithGoogle = await signInWithGoogleUsecase(
      NoParams(),
    );
    emit(_eitherSignInWithGoogleOrFailure(failureOrSignOutWithGoogle));
  }

  AuthenticationState _eitherSignInWithGoogleOrFailure(
      Either<Failure, User?> failureOrSignOutWithGoogle) {
    return failureOrSignOutWithGoogle.fold(
      (error) => const SignInWithGoogleState(status: AuthStatus.error),
      (user) => SignInWithGoogleState(
        status: AuthStatus.loaded,
        user: user,
      ),
    );
  }

  void _onSignOutWithGoogle(
      SignOutWithGoogleEvent event, Emitter<AuthenticationState> emit) async {
    emit(const SignInWithGoogleState(status: AuthStatus.loading));
    final failureOrSignOutWithGoogle = await signOutWithGoogleUsecase(
      NoParams(),
    );
    emit(_eitherSignOutWithGoogleOrFailure(failureOrSignOutWithGoogle));
  }

  AuthenticationState _eitherSignOutWithGoogleOrFailure(
      Either<Failure, void> failureOrSignOutWithGoogle) {
    return failureOrSignOutWithGoogle.fold(
      (error) => SignOutWithGoogleState(
        status: AuthStatus.error,
        errorMessage: error.errorMessage,
      ),
      (user) => const SignOutWithGoogleState(
        status: AuthStatus.loaded,
      ),
    );
  }

  void _onAuthenticatedWithGoogle(AuthenticatedWithGoogleEvent event,
      Emitter<AuthenticationState> emit) async {
    emit(const AuthenticatedWithGoogleState(status: AuthStatus.loading));
    final failureOrIsAuthenticatedWithGoogle = await getSignInWithGoogleUsecase(
      NoParams(),
    );
    emit(
      _eitherIsAuthenticatedWithGoogleOrFailure(
        failureOrIsAuthenticatedWithGoogle,
      ),
    );
  }

  AuthenticationState _eitherIsAuthenticatedWithGoogleOrFailure(
      Either<Failure, bool> failureOrIsAuthenticatedWithGoogle) {
    return failureOrIsAuthenticatedWithGoogle.fold(
      (error) => AuthenticatedWithGoogleState(
        status: AuthStatus.error,
        errorMessage: error.errorMessage,
      ),
      (success) => const AuthenticatedWithGoogleState(
        status: AuthStatus.loaded,
      ),
    );
  }
}
