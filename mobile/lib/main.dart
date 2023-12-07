import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skill_bridge_mobile/features/bookmarks/presentation/bloc/addContentBookmarkBloc/add_content_bookmark_bloc_bloc.dart';
import 'package:skill_bridge_mobile/features/bookmarks/presentation/bloc/bookmarksBoc/bookmarks_bloc_bloc.dart';
import 'package:skill_bridge_mobile/features/question/presentation/bloc/endOfChaptersQuestionsBloc/endof_chapter_questions_bloc.dart';
import 'package:skill_bridge_mobile/firebase_options.dart';
import 'features/bookmarks/presentation/bloc/addQuestionBookmarkBloc/add_question_bookmark_bloc.dart';
import 'package:skill_bridge_mobile/features/profile/presentation/bloc/changePasswordBloc/password_bloc.dart';
import 'package:skill_bridge_mobile/features/profile/presentation/bloc/changeUsernameBloc/username_bloc.dart';
import 'features/bookmarks/presentation/bloc/deleteContentBookmark/delete_content_bookmark_bloc.dart';
import 'package:skill_bridge_mobile/features/profile/presentation/bloc/userProfile/userProfile_bloc.dart';
import 'features/bookmarks/presentation/bloc/deleteQuestionBookmarkBloc/delete_question_bookmark_bloc.dart';
import 'features/course/presentation/bloc/course/course_bloc.dart';
import 'features/profile/presentation/bloc/logout/logout_bloc.dart';
// import 'package:firebase_core/firebase_core.dart';

// import 'firebase_options.dart';
import 'core/core.dart';
import 'features/features.dart';
import 'features/profile/presentation/bloc/usersLeaderboard/users_leaderboard_bloc.dart';
import 'injection_container.dart' as di;
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
    // FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance);
  } catch (e) {
    print('Failed to initialize Firebase $e');
  }

  await di.init();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (_) => serviceLocator<AuthenticationBloc>(),
        ),
        BlocProvider<SignupFormBloc>(
          create: (_) => serviceLocator<SignupFormBloc>(),
        ),
        BlocProvider<ChangePasswordFormBloc>(
          create: (_) => serviceLocator<ChangePasswordFormBloc>(),
        ),
        BlocProvider<GetUserBloc>(
          create: (_) => serviceLocator<GetUserBloc>(),
        ),
        BlocProvider<HomeBloc>(
          create: (_) => serviceLocator<HomeBloc>(),
        ),
        BlocProvider<GetExamDateBloc>(
          create: (_) => serviceLocator<GetExamDateBloc>(),
        ),
        BlocProvider<DepartmentBloc>(
          create: (_) => serviceLocator<DepartmentBloc>(),
        ),
        BlocProvider<UserCoursesBloc>(
          create: (_) => serviceLocator<UserCoursesBloc>(),
        ),
        BlocProvider<SelectDepartmentBloc>(
          create: (_) => serviceLocator<SelectDepartmentBloc>(),
        ),
        BlocProvider<CourseWithUserAnalysisBloc>(
          create: (_) => serviceLocator<CourseWithUserAnalysisBloc>(),
        ),
        BlocProvider<SelectCourseBloc>(
          create: (_) => serviceLocator<SelectCourseBloc>(),
        ),
        BlocProvider<CourseBloc>(
          create: (_) => serviceLocator<CourseBloc>(),
        ),
        BlocProvider<ChatWithContentBloc>(
          create: (_) => serviceLocator<ChatWithContentBloc>(),
        ),
        BlocProvider<DepartmentCourseBloc>(
          create: (_) => serviceLocator<DepartmentCourseBloc>(),
        ),
        BlocProvider<SelectCourseBloc>(
          create: (_) => serviceLocator<SelectCourseBloc>(),
        ),
        BlocProvider<SearchCourseBloc>(
          create: (_) => serviceLocator<SearchCourseBloc>(),
        ),
        BlocProvider<MockExamBloc>(
          create: (_) => serviceLocator<MockExamBloc>(),
        ),
        BlocProvider<MyMocksBloc>(
          create: (_) => serviceLocator<MyMocksBloc>(),
        ),
        BlocProvider<MockQuestionBloc>(
          create: (_) => serviceLocator<MockQuestionBloc>(),
        ),
        BlocProvider<UserMockBloc>(
          create: (_) => serviceLocator<UserMockBloc>(),
        ),
        BlocProvider<UpsertMockScoreBloc>(
          create: (_) => serviceLocator<UpsertMockScoreBloc>(),
        ),
        BlocProvider<ChapterBloc>(
          create: (_) => serviceLocator<ChapterBloc>(),
        ),
        BlocProvider<SubChapterBloc>(
          create: (_) => serviceLocator<SubChapterBloc>(),
        ),
        BlocProvider<QuestionBloc>(
          create: (_) => serviceLocator<QuestionBloc>(),
        ),
        BlocProvider<PopupMenuBloc>(
          create: (_) => serviceLocator<PopupMenuBloc>(),
        ),
        BlocProvider<QuizBloc>(
          create: (_) => serviceLocator<QuizBloc>(),
        ),
        BlocProvider<QuizCreateBloc>(
          create: (_) => serviceLocator<QuizCreateBloc>(),
        ),
        BlocProvider<QuizQuestionBloc>(
          create: (_) => serviceLocator<QuizQuestionBloc>(),
        ),
        BlocProvider<RegisterCourseBloc>(
          create: (_) => serviceLocator<RegisterCourseBloc>(),
        ),
        BlocProvider<LogoutBloc>(create: (_) => serviceLocator<LogoutBloc>()),
        BlocProvider<SubChapterRegstrationBloc>(
          create: (_) => serviceLocator<SubChapterRegstrationBloc>(),
        ),
        BlocProvider<ChatBloc>(
          create: (_) => serviceLocator<ChatBloc>(),
        ),
        BlocProvider<FeedbackBloc>(
          create: (_) => serviceLocator<FeedbackBloc>(),
        ),
        BlocProvider<QuestionVoteBloc>(
          create: (_) => serviceLocator<QuestionVoteBloc>(),
        ),
        BlocProvider<OnboardingBloc>(
          create: (_) => serviceLocator<OnboardingBloc>(),
        ),
        BlocProvider<BookmarksBlocBloc>(
          create: (_) => serviceLocator<BookmarksBlocBloc>(),
        ),
        BlocProvider<AddContentBookmarkBlocBloc>(
          create: (_) => serviceLocator<AddContentBookmarkBlocBloc>(),
        ),
        BlocProvider<DeleteContentBookmarkBloc>(
          create: (_) => serviceLocator<DeleteContentBookmarkBloc>(),
        ),
        BlocProvider<AlertDialogBloc>(
          create: (_) => serviceLocator<AlertDialogBloc>(),
        ),
        BlocProvider<UserProfileBloc>(
          create: (_) => serviceLocator<UserProfileBloc>(),
        ),
        BlocProvider<AddQuestionBookmarkBloc>(
          create: (_) => serviceLocator<AddQuestionBookmarkBloc>(),
        ),
        BlocProvider<DeleteQuestionBookmarkBloc>(
          create: (_) => serviceLocator<DeleteQuestionBookmarkBloc>(),
        ),
        BlocProvider<EndofChapterQuestionsBloc>(
          create: (_) => serviceLocator<EndofChapterQuestionsBloc>(),
        ),
        BlocProvider<UsernameBloc>(
          create: (_) => serviceLocator<UsernameBloc>(),
        ),
        BlocProvider<PasswordBloc>(
          create: (_) => serviceLocator<PasswordBloc>(),
        ),
        BlocProvider<UsersLeaderboardBloc>(
          create: (_) => serviceLocator<UsersLeaderboardBloc>(),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // navigatorObservers: [
      //   FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance)
      // ],
      debugShowCheckedModeBanner: false,
      home: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overScroll) {
          overScroll.disallowIndicator();
          return true;
        },
        child: SafeArea(
          child: DefaultTextStyle(
            style: const TextStyle(fontFamily: 'Poppins'),
            child: DismissKeyboard(
              child: ResponsiveSizer(
                builder: (context, orientation, screenType) {
                  return AppRouter(
                    localDatasource:
                        serviceLocator<AuthenticationLocalDatasource>(),
                  );
                },
              ),
            ),
            // Timer(),
          ),
        ),
      ),
    );
  }
}
