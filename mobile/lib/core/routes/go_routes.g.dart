// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'go_routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $onboardingPagesRoute,
      $loginPageRoute,
      $signupPageRoute,
      $cubeAnimationPageRoute,
      $homePageRoute,
    ];

RouteBase get $onboardingPagesRoute => GoRouteData.$route(
      path: '/onboarding',
      name: 'onboarding',
      factory: $OnboardingPagesRouteExtension._fromState,
    );

extension $OnboardingPagesRouteExtension on OnboardingPagesRoute {
  static OnboardingPagesRoute _fromState(GoRouterState state) =>
      OnboardingPagesRoute();

  String get location => GoRouteData.$location(
        '/onboarding',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $loginPageRoute => GoRouteData.$route(
      path: '/login',
      name: 'login',
      factory: $LoginPageRouteExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: 'forgot-password',
          name: 'forgotPassword',
          factory: $ForgotPasswordPageRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: 'otp',
              name: 'forgotPasswordOtp',
              factory: $ForgotPasswordOtpPageRouteExtension._fromState,
            ),
            GoRouteData.$route(
              path: 'change-password',
              name: 'changePassword',
              factory: $ChangePasswordPageRouteExtension._fromState,
            ),
          ],
        ),
        GoRouteData.$route(
          path: 'new-password-confirmed',
          name: 'newPasswordConfirmed',
          factory: $NewPasswordConfirmedPageRouteExtension._fromState,
        ),
      ],
    );

extension $LoginPageRouteExtension on LoginPageRoute {
  static LoginPageRoute _fromState(GoRouterState state) => LoginPageRoute();

  String get location => GoRouteData.$location(
        '/login',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ForgotPasswordPageRouteExtension on ForgotPasswordPageRoute {
  static ForgotPasswordPageRoute _fromState(GoRouterState state) =>
      ForgotPasswordPageRoute();

  String get location => GoRouteData.$location(
        '/login/forgot-password',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ForgotPasswordOtpPageRouteExtension on ForgotPasswordOtpPageRoute {
  static ForgotPasswordOtpPageRoute _fromState(GoRouterState state) =>
      ForgotPasswordOtpPageRoute(
        emailOrPhoneNumber: state.queryParameters['email-or-phone-number']!,
      );

  String get location => GoRouteData.$location(
        '/login/forgot-password/otp',
        queryParams: {
          'email-or-phone-number': emailOrPhoneNumber,
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ChangePasswordPageRouteExtension on ChangePasswordPageRoute {
  static ChangePasswordPageRoute _fromState(GoRouterState state) =>
      ChangePasswordPageRoute();

  String get location => GoRouteData.$location(
        '/login/forgot-password/change-password',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $NewPasswordConfirmedPageRouteExtension
    on NewPasswordConfirmedPageRoute {
  static NewPasswordConfirmedPageRoute _fromState(GoRouterState state) =>
      NewPasswordConfirmedPageRoute();

  String get location => GoRouteData.$location(
        '/login/new-password-confirmed',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $signupPageRoute => GoRouteData.$route(
      path: '/signup',
      name: 'signup',
      factory: $SignupPageRouteExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: 'otp',
          name: 'signupOtp',
          factory: $SignupOtpPageRouteExtension._fromState,
        ),
      ],
    );

extension $SignupPageRouteExtension on SignupPageRoute {
  static SignupPageRoute _fromState(GoRouterState state) => SignupPageRoute();

  String get location => GoRouteData.$location(
        '/signup',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $SignupOtpPageRouteExtension on SignupOtpPageRoute {
  static SignupOtpPageRoute _fromState(GoRouterState state) =>
      SignupOtpPageRoute(
        emailOrPhoneNumber: state.queryParameters['email-or-phone-number']!,
      );

  String get location => GoRouteData.$location(
        '/signup/otp',
        queryParams: {
          'email-or-phone-number': emailOrPhoneNumber,
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $cubeAnimationPageRoute => GoRouteData.$route(
      path: '/cube-animation',
      factory: $CubeAnimationPageRouteExtension._fromState,
    );

extension $CubeAnimationPageRouteExtension on CubeAnimationPageRoute {
  static CubeAnimationPageRoute _fromState(GoRouterState state) =>
      CubeAnimationPageRoute();

  String get location => GoRouteData.$location(
        '/cube-animation',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $homePageRoute => GoRouteData.$route(
      path: '/',
      name: 'home',
      factory: $HomePageRouteExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: 'profile',
          name: 'profile',
          factory: $ProfilePageRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: 'userLeaderboard',
              factory: $UserLeaderboardPageRouteExtension._fromState,
            ),
          ],
        ),
      ],
    );

extension $HomePageRouteExtension on HomePageRoute {
  static HomePageRoute _fromState(GoRouterState state) => HomePageRoute();

  String get location => GoRouteData.$location(
        '/',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ProfilePageRouteExtension on ProfilePageRoute {
  static ProfilePageRoute _fromState(GoRouterState state) => ProfilePageRoute();

  String get location => GoRouteData.$location(
        '/profile',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $UserLeaderboardPageRouteExtension on UserLeaderboardPageRoute {
  static UserLeaderboardPageRoute _fromState(GoRouterState state) =>
      UserLeaderboardPageRoute(
        state.extra as UserLeaderboardEntity,
      );

  String get location => GoRouteData.$location(
        '/profile/userLeaderboard',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

bool _$boolConverter(String value) {
  switch (value) {
    case 'true':
      return true;
    case 'false':
      return false;
    default:
      throw UnsupportedError('Cannot convert "$value" into a bool.');
  }
}
