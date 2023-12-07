import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import '../../features/authentication/presentation/pages/cube_animation_page.dart';
// import '../../features/authentication/presentation/pages/select_path_page.dart';
// import '../../features/course/presentation/pages/content_final_page.dart';
// import '../../features/course/presentation/pages/content_page.dart';
// import '../../features/course/presentation/pages/course_detail_page_new.dart';
// import '../../features/course/presentation/pages/learning_path_page.dart';
// import '../../features/onboarding/presentation/pages/question_onboarding_pages.dart';
// import '../../features/profile/presentation/pages/settings_page.dart';
// import '../widgets/starting_page_with_bottom_nav.dart';
// import '../../features/course/presentation/pages/learn_path.dart';

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
    print(route.settings.name);
  }
}

// final routes = <GoRoute>[
//   GoRoute(
//     path: AppRoutes.onboardingPages,
//     builder: (BuildContext context, GoRouterState state) =>
//         const OnboardingPages(),
//   ),
//   GoRoute(
//     path: AppRoutes.login,
//     builder: (BuildContext context, GoRouterState state) => const LoginPage(),
//   ),
//   GoRoute(
//     path: AppRoutes.signup,
//     builder: (BuildContext context, GoRouterState state) => const SignupPage(),
//   ),
//   GoRoute(
//     path: AppRoutes.forgotPassword,
//     builder: (BuildContext context, GoRouterState state) =>
//         const ForgotPasswordPage(),
//   ),
//   GoRoute(
//     path: AppRoutes.changePassword,
//     builder: (BuildContext context, GoRouterState state) =>
//         const ChangePasswordPage(),
//   ),
//   GoRoute(
//     path: AppRoutes.newPasswordConfirmedPage,
//     builder: (BuildContext context, GoRouterState state) =>
//         const NewPasswordConfirmedPage(),
//   ),
//   GoRoute(
//     path: AppRoutes.otpPage,
//     builder: (BuildContext context, GoRouterState state) {
//       return OTPPage(
//         from: state.extra as String,
//       );
//     },
//   ),
//   GoRoute(
//     path: AppRoutes.selectDepartmentPage,
//     builder: (BuildContext context, GoRouterState state) {
//       return const SelectDepartmentPage();
//     },
//   ),
//   GoRoute(
//     path: AppRoutes.selectFieldOfStudyPage,
//     builder: (BuildContext context, GoRouterState state) {
//       return SelectFieldOfStudyPage(
//         departments: state.extra as List<Department>,
//       );
//     },
//   ),
//   GoRoute(
//     path: AppRoutes.cubeRotateLoadingPage,
//     builder: (BuildContext context, GoRouterState state) {
//       return const CubeAnimationPage();
//     },
//   ),
//   GoRoute(
//     path: AppRoutes.home,
//     builder: (BuildContext context, GoRouterState state) => HomePage(
//       navigateToSettings: state.extra as VoidCallback,
//     ),
//   ),
//   // GoRoute(
//   //   path: AppRoutes.updatedHomePage,
//   //   builder: (BuildContext context, GoRouterState state) =>
//   //       const UpdatedHomePage(),
//   // ),
//   GoRoute(
//     path: AppRoutes.chatPage,
//     builder: (BuildContext context, GoRouterState state) =>
//         ChatPage(questionId: state.extra as String),
//     // const ChatPage(questionId: ''),
//   ),
//   GoRoute(
//     path: AppRoutes.mockListPage,
//     builder: (BuildContext context, GoRouterState state) =>
//         const MockListPage(),
//   ),
//   GoRoute(
//     path: AppRoutes.updatedMockExamPage,
//     builder: (BuildContext context, GoRouterState state) =>
//         const MockExamPage(),
//   ),
//   GoRoute(
//     path: AppRoutes.universityMockExamPage,
//     builder: (BuildContext context, GoRouterState state) =>
//         const UniversityMockExamPage(),
//   ),
//   GoRoute(
//     path: AppRoutes.aiGeneratedExamsPage,
//     builder: (BuildContext context, GoRouterState state) =>
//         const AiGeneratedExamsPage(),
//   ),
//   GoRoute(
//     path: AppRoutes.mockChooseGeneralDepartmentPage,
//     builder: (BuildContext context, GoRouterState state) =>
//         const MockChooseGeneralDepartmentPage(),
//   ),
//   GoRoute(
//     path: AppRoutes.mockChooseDepartmentPage,
//     builder: (BuildContext context, GoRouterState state) =>
//         MockChooseDepartmentPage(
//       departments: state.extra as List<Department>,
//     ),
//   ),
//   GoRoute(
//     path: AppRoutes.searchPage,
//     builder: (BuildContext context, GoRouterState state) =>
//         const SearchCoursePage(),
//   ),
//   GoRoute(
//     path: AppRoutes.chooseSubjectPage,
//     builder: (BuildContext context, GoRouterState state) =>
//         ChooseSubjectPage(forQuestionGeneration: state.extra as bool),
//   ),
//   GoRoute(
//     path: AppRoutes.myExamPage,
//     builder: (BuildContext context, GoRouterState state) => const MyExamPage(),
//   ),
//   GoRoute(
//     path: AppRoutes.mockExamsPage,
//     builder: (BuildContext context, GoRouterState state) =>
//         const MockExamsPage(),
//   ),
//   GoRoute(
//     path: AppRoutes.mockExamQuestionPage,
//     builder: (BuildContext context, GoRouterState state) =>
//         MockExamQuestionsPage(
//       mockExamQuestionPageParams: state.extra as MockExamQuestionPageParams,
//     ),
//   ),
//   GoRoute(
//     path: AppRoutes.quizListPage,
//     builder: (BuildContext context, GoRouterState state) => QuizListPage(
//       course: state.extra as Course,
//     ),
//   ),
//   GoRoute(
//     path: AppRoutes.quizGeneratorPage,
//     builder: (BuildContext context, GoRouterState state) => QuizGeneratorPage(
//       quizGeneratorPageParams: state.extra as QuizGeneratorPageParams,
//     ),
//   ),
//   // GoRoute(
//   //   path: AppRoutes.generateQuizPage,
//   //   builder: (BuildContext context, GoRouterState state) =>
//   //       const CreateQuizPage(),
//   // ),
//   GoRoute(
//     path: AppRoutes.quizExamPage,
//     builder: (BuildContext context, GoRouterState state) =>
//         QuizExamQuestionsPage(
//       quizExamQuestionPageParams: state.extra as QuizExamQuestionPageParams,
//     ),
//   ),
//   GoRoute(
//     path: AppRoutes.myhomePage,
//     builder: (BuildContext context, GoRouterState state) => const MyHomePage(),
//   ),
//   GoRoute(
//     path: AppRoutes.resultPage,
//     builder: (BuildContext context, GoRouterState state) => ResultPage(
//       resultPageParams: state.extra as ResultPageParams,
//     ),
//   ),
//   GoRoute(
//     path: AppRoutes.courseOption,
//     builder: (BuildContext context, GoRouterState state) =>
//         CourseOptionsPage(course: state.extra as Course),
//   ),
//   GoRoute(
//     path: AppRoutes.myCoursesPage,
//     builder: (BuildContext context, GoRouterState state) =>
//         const MyCoursesPage(),
//   ),
//   GoRoute(
//     path: AppRoutes.allCoursesPage,
//     builder: (BuildContext context, GoRouterState state) =>
//         const AlloursesPage(),
//   ),
//   GoRoute(
//     path: AppRoutes.chooseDepartment,
//     builder: (BuildContext context, GoRouterState state) =>
//         const ChooseDepartmentPage(),
//   ),
//   GoRoute(
//     path: AppRoutes.selectCourse,
//     builder: (BuildContext context, GoRouterState state) =>
//         const SelectCoursePage(),
//   ),
//   GoRoute(
//     path: AppRoutes.courseDetail,
//     builder: (BuildContext context, GoRouterState state) =>
//         const CourseDetailPageNew(),
//   ),
//   GoRoute(
//     path: AppRoutes.learningPath,
//     builder: (BuildContext context, GoRouterState state) => LearningPathPage(
//       userChapterAnalysis: state.extra as UserChapterAnalysis,
//     ),
//   ),
//   GoRoute(
//     path: AppRoutes.contentpage,
//     builder: (BuildContext context, GoRouterState state) => ContentPage(
//       courseId: state.extra as String,
//     ),
//   ),
//   GoRoute(
//     path: AppRoutes.settingsPage,
//     builder: (BuildContext context, GoRouterState state) =>
//         const SettingsPage(),
//   ),
//   GoRoute(
//     path: AppRoutes.endOfSubtopicQuestionsPage,
//     builder: (BuildContext context, GoRouterState state) =>
//         EndOfSubtopicQuestionsPage(
//       subTopicId: state.extra as String,
//     ),
//   ),
//   GoRoute(
//     path: AppRoutes.endOfChapterPage,
//     builder: (BuildContext context, GoRouterState state) =>
//         EndOfChapterPage(subTopicId: state.extra as String),
//   ),
//   GoRoute(
//     path: AppRoutes.endOfQuestionPage,
//     builder: (BuildContext context, GoRouterState state) =>
//         const EndOfQuestionPage(),
//   ),
//   GoRoute(
//     path: AppRoutes.learingPathPage,
//     builder: (BuildContext context, GoRouterState state) => LearningPathScreen(
//       userChapterAnalysis: state.extra as UserChapterAnalysis,
//     ),
//   ),
//   GoRoute(
//     path: AppRoutes.selectPath,
//     builder: (BuildContext context, GoRouterState state) =>
//         const SelectPathPage(),
//   ),
//   GoRoute(
//     path: AppRoutes.questionOnboardingPages,
//     builder: (BuildContext context, GoRouterState state) =>
//         const OnboardingQuestionPages(),
//   ),
//   GoRoute(
//     path: AppRoutes.contentFinalPage,
//     builder: (BuildContext context, GoRouterState state) =>
//         const ContentFinalPage(),
//   ),

//   //! Course Related Routes
//   GoRoute(
//     path: '/course/:courseId',
//     builder: (context, state) {
//       final courseId = state.pathParameters['courseId'] as String;
//       return CourseDetailPageNew(courseId: courseId);
//     },
//     routes: [
//       GoRoute(
//         path: 'chapter/:chapterId',
//         builder: (context, state) {
//           final chapterId = state.pathParameters['chapterId'] as String;
//           return CourseDetailPageNew(
//             chapterId: chapterId,
//           );
//         },
//       ),
//       GoRoute(
//         path: 'quiz',
//         builder: (context, state) {
//           final courseId = state.pathParameters['courseId'] as String;
//           return CourseDetailPageNew(
//             chapterId: courseId,
//           );
//         },
//         routes: [
//           GoRoute(
//             path: 'new',
//             builder: (context, state) {
//               final courseId = state.pathParameters['courseId'] as String;
//               return CreateQuizPage(courseId: courseId);
//             },
//           ),
//         ],
//       ),
//     ],
//   ),
// ];
