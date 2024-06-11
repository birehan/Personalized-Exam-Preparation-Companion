import 'dart:async';
import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:prep_genie/core/bloc/routerBloc/router_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:upgrader/upgrader.dart';

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

  FutureOr<String?> redirector(state) async {
    var isLoggedIn = true;
    var isAppInitialized = true;
    var isDepartmentSelected = true;
    // return OnboardingQuestionPagesRoute().location;
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
      if (!isDepartmentSelected) {
        return OnboardingQuestionPagesRoute().location;
      } else if (state.location == OnboardingPagesRoute().location) {
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
    required this.context,
  }) : super(key: key) {
    _router = GoRouter(
      debugLogDiagnostics: true,
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
    FirebaseDynamicLinks.instance.onLink
        .listen((PendingDynamicLinkData? dynamicLink) {
      if (dynamicLink != null) {
        handleDeepLinkData(dynamicLink);
      }
    });
  }

  // Handle the deep link data
  void handleDeepLinkData(PendingDynamicLinkData dynamicLink) async {
    final Uri deepLink = dynamicLink.link;
    // final String route = deepLink.pathSegments.first;
    Map<String, String> queryParams = deepLink.queryParameters;
    try {
      // check if the user already signed in
      await localDatasource.getUserCredential();
    } on CacheException {
      if (queryParams['referalCode'] != null) {
        await localDatasource.storeReferralId(
            referalUserId: queryParams['referalCode']!);
      }
      return;
    }
    if (queryParams['route'] != null) {
      _router.go(queryParams['route']!);
    } else {
      _router.go('/');
    }
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
            builder: (context, child) {
              return UpgradeAlert(
                navigatorKey: _router.routerDelegate.navigatorKey,
                child: child ?? Text('child'),
              );
            },
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
