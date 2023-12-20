import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core.dart';
import '../../features/features.dart';

class AppRouter extends StatelessWidget {
  final AuthenticationLocalDatasource localDatasource;
  late final GoRouter _router;

  void popUntil(bool Function(String) predicate) {
    while (!predicate(_router.location)) {
      _router.pop();
    }
  }

  FutureOr<String?> redirector(state) async {
    var isLoggedIn = true;
    var isAppInitialized = true;
    var isDepartmentSelected = true;

    try {
      // await localDatasource.getUserCredential();
      var userCredential = await localDatasource.getUserCredential();
      isDepartmentSelected =
          userCredential.department != '' && userCredential.departmentId != '';
    } on CacheException {
      isLoggedIn = false;
    }
    // print(isLoggedIn);
    try {
      await localDatasource.getAppInitialization();
    } on CacheException {
      isAppInitialized = false;
    }

    if (isLoggedIn) {
      if (state.location == OnboardingPagesRoute().location) {
        return HomePageRoute().location;
      }
      return state.location;
    } else if (isAppInitialized) {
      if (state.location == OnboardingPagesRoute().location) {
        return LoginPageRoute().location;
      }
      return state.location;
      // return AppRoutes.onboardingPages;
    } else {
      return null;
    }
  }

  AppRouter({
    Key? key,
    required this.localDatasource,
  }) : super(key: key) {
    _router = GoRouter(
      redirect: ((context, state) => redirector(state)),
      initialLocation: OnboardingPagesRoute().location,
      routes: $appRoutes,
      observers: [
        GoRouterObserver(
          analytics: FirebaseAnalytics.instance,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A7A6C)),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A7A6C),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          dialogBackgroundColor: Colors.white,
        ),
        debugShowCheckedModeBanner: false,
        routeInformationProvider: _router.routeInformationProvider,
        routeInformationParser: _router.routeInformationParser,
        routerDelegate: _router.routerDelegate,
      );
}

class GoRouterObserver extends NavigatorObserver {
  GoRouterObserver({
    required this.analytics,
  });

  final FirebaseAnalytics analytics;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    analytics.setCurrentScreen(screenName: route.settings.name);
  }
}
