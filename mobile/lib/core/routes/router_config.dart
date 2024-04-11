import 'dart:async';
import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:prepgenie/core/bloc/routerBloc/router_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../l10n/l10n.dart';
import '../bloc/localeBloc/locale_bloc.dart';
import '../core.dart';
import '../../features/features.dart';

class AppRouter extends StatelessWidget {
  final AuthenticationLocalDatasource localDatasource;
  final BuildContext context;
  late final GoRouter _router;

  void popUntil(bool Function(String) predicate) {
    while (!predicate(_router.location)) {
      _router.pop();
    }
  }

  // FutureOr<String?> redirector(state) async {
  //   var isLoggedIn = true;
  //   var isAppInitialized = true;
  //   var isDepartmentSelected = true; // Remove this line as department information is no longer available

  //   try {
  //     // Check if the user is logged in
  //     await localDatasource.getUserCredential();
  //   } on CacheException {
  //     isLoggedIn = false;
  //   }

  //   try {
  //     await localDatasource.getAppInitialization();
  //   } on CacheException {
  //     isAppInitialized = false;
  //   }

  //   if (isLoggedIn) {
  //     // User is logged in, navigate directly to home page
  //     return HomePageRoute().location;
  //   } else if (isAppInitialized) {
  //     // App is initialized but user is not logged in, navigate to onboarding page
  //     return OnboardingPagesRoute().location;
  //   } else {
  //     // App is not initialized, handle accordingly (e.g., show splash screen or loading indicator)
  //     return null;
  //   }
  // }

  //TODO: Handle the transition between onboarding and home page needs more work:
  FutureOr<String?> redirector(state) async {
    var isLoggedIn = true;
    var isAppInitialized = true;
    var isDepartmentSelected = true;
    var firstLogin = false;
    // return LoginPageRoute().location;
    try {
      // await localDatasource.getUserCredential();
      var userCredential = await localDatasource.getUserCredential();
      // isDepartmentSelected =
      //     userCredential.department != '' && userCredential.departmentId != '';
      isDepartmentSelected = userCredential.howPrepared != '';
    } on CacheException {
      isLoggedIn = false;
      firstLogin = true;
    }
    // print(isLoggedIn);
    try {
      await localDatasource.getAppInitialization();
    } on CacheException {
      isAppInitialized = false;
    }

    if (isLoggedIn) {
      if (firstLogin) {
        return OnboardingQuestionPagesRoute().location;
      } else if (state.location == OnboardingPagesRoute().location) {
        return HomePageRoute().location;
      }
      return state.location;
    } else if (isAppInitialized) {
      if (state.location == OnboardingPagesRoute().location) {
        firstLogin = true;
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
    required this.context,
  }) : super(key: key) {
    _router = GoRouter(
      redirect: ((context, state) => redirector(state)),
      initialLocation: OnboardingPagesRoute().location,
      routes: $appRoutes,
      observers: [
        GoRouterObserver(
          analytics: FirebaseAnalytics.instance,
          context: context,
        ),
      ],
    );
    // print(AppLocalizations.of(context)!.name);
    // print(context.toString());
    handleDeepLink();
    context.read<RouterBloc>().add(PopulateRouterBloc(router: _router));
  }
  // Handle Firebase Dynamic Links
  Future<void> handleDeepLink() async {
    // Check if the app was launched from a Dynamic Link
    final PendingDynamicLinkData? initialLink =
        await FirebaseDynamicLinks.instance.getInitialLink();

    if (initialLink != null) {
      handleDeepLinkData(initialLink);
    }

    // Listen for Dynamic Link changes
    FirebaseDynamicLinks.instance.onLink
        .listen((PendingDynamicLinkData? dynamicLink) {
      if (dynamicLink != null) {
        handleDeepLinkData(dynamicLink);
      }
    });
  }

  // Handle the deep link data
  void handleDeepLinkData(PendingDynamicLinkData dynamicLink) {
    final Uri deepLink = dynamicLink.link;
    Map<String, String> queryParams = deepLink.queryParameters;
    // use the link to navigate to any section. here it only navigate to contest page section every link
    _router.go(
      '/contest/${queryParams['contestId']}',
    );
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<LocaleBloc, LocaleState>(
        builder: (context, state) {
          print('locale: ${state.currentLocale}');
          return MaterialApp.router(
            supportedLocales: L10n.supportedLangages,
            locale: Locale(state.currentLocale),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: ThemeData(
              useMaterial3: true,
              colorScheme:
                  ColorScheme.fromSeed(seedColor: const Color(0xFF1A7A6C)),
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
        },
      );
}

class GoRouterObserver extends NavigatorObserver {
  GoRouterObserver({
    required this.analytics,
    required this.context,
  });

  final FirebaseAnalytics analytics;
  final BuildContext context;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    analytics.setCurrentScreen(screenName: route.settings.name);
    print('current page ${route.settings.name}');
    if (route.settings.name != null) {
      context
          .read<RouterBloc>()
          .add(PageChangedEvent(pageName: route.settings.name!));
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (previousRoute != null && previousRoute.settings.name != null) {
      context
          .read<RouterBloc>()
          .add(PageChangedEvent(pageName: previousRoute.settings.name!));
    }
  }

  // @override
  // void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
  //   if (newRoute.settings.name != null) {
  //     context
  //         .read<RouterBloc>()
  //         .add(PageChangedEvent(pageName: route.settings.name!));
  //   }
  // }
}
