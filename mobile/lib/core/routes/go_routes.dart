import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skill_bridge_mobile/features/authentication/presentation/pages/cube_animation_page.dart';
import 'package:skill_bridge_mobile/features/profile/presentation/pages/user_leaderboard_page.dart';

import '../../features/features.dart';
import '../../features/profile/domain/entities/user_leaderboard_entity.dart';
import '../core.dart';

part 'go_routes.g.dart';

@TypedGoRoute<OnboardingPagesRoute>(
  name: 'onboarding',
  path: '/onboarding',
)
class OnboardingPagesRoute extends GoRouteData {
  OnboardingPagesRoute();

  @override
  Widget build(context, state) => const OnboardingPages();
}

@TypedGoRoute<LoginPageRoute>(
  name: 'login',
  path: '/login',
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<ForgotPasswordPageRoute>(
      name: 'forgotPassword',
      path: 'forgot-password',
      routes: <TypedGoRoute<GoRouteData>>[
        TypedGoRoute<ForgotPasswordOtpPageRoute>(
          name: 'forgotPasswordOtp',
          path: 'otp',
        ),
        TypedGoRoute<ChangePasswordPageRoute>(
          name: 'changePassword',
          path: 'change-password',
        ),
      ],
    ),
    TypedGoRoute<NewPasswordConfirmedPageRoute>(
      name: 'newPasswordConfirmed',
      path: 'new-password-confirmed',
    ),
  ],
)
class LoginPageRoute extends GoRouteData {
  LoginPageRoute();

  @override
  Widget build(context, state) => const LoginPage();
}

class ForgotPasswordPageRoute extends GoRouteData {
  ForgotPasswordPageRoute();

  @override
  Widget build(context, state) => const ForgotPasswordPage();
}

class ForgotPasswordOtpPageRoute extends GoRouteData {
  ForgotPasswordOtpPageRoute({
    required this.emailOrPhoneNumber,
  });

  final String emailOrPhoneNumber;

  @override
  Widget build(context, state) => OTPPage(
        emailOrPhoneNumber: emailOrPhoneNumber,
        from: ForgotPasswordPageRoute().location,
      );
}

class ChangePasswordPageRoute extends GoRouteData {
  ChangePasswordPageRoute();

  @override
  Widget build(context, state) => const ChangePasswordPage();
}

class NewPasswordConfirmedPageRoute extends GoRouteData {
  NewPasswordConfirmedPageRoute();

  @override
  Widget build(context, state) => const NewPasswordConfirmedPage();
}

@TypedGoRoute<SignupPageRoute>(
  name: 'signup',
  path: '/signup',
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<SignupOtpPageRoute>(
      name: 'signupOtp',
      path: 'otp',
    ),
  ],
)
class SignupPageRoute extends GoRouteData {
  SignupPageRoute();

  @override
  Widget build(context, state) => const SignupPage();
}

class SignupOtpPageRoute extends GoRouteData {
  SignupOtpPageRoute({
    required this.emailOrPhoneNumber,
  });
  final String emailOrPhoneNumber;

  @override
  Widget build(context, state) => OTPPage(
        emailOrPhoneNumber: emailOrPhoneNumber,
        from: SignupPageRoute().location,
      );
}

@TypedGoRoute<CubeAnimationPageRoute>(path: '/cube-animation')
class CubeAnimationPageRoute extends GoRouteData {
  CubeAnimationPageRoute();

  @override
  Widget build(context, state) => const CubeAnimationPage();
}

@TypedGoRoute<HomePageRoute>(
  name: 'home',
  path: '/',
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<ProfilePageRoute>(
      name: 'profile',
      path: 'profile',
      routes: <TypedGoRoute<GoRouteData>>[
        TypedGoRoute<UserLeaderboardPageRoute>(
          path: 'userLeaderboard',
        ),
      ],
    ),
  ],
)
class HomePageRoute extends GoRouteData {
  HomePageRoute();

  @override
  Widget build(context, state) => const MyHomePage();
}

class ProfilePageRoute extends GoRouteData {
  ProfilePageRoute();

  @override
  Widget build(context, state) => const ProfilePage();
}

class UserLeaderboardPageRoute extends GoRouteData {
  final UserLeaderboardEntity $extra;

  UserLeaderboardPageRoute(this.$extra);
  @override
  Widget build(context, state) => UserLeaderboardPage(userInformations: $extra);
}
