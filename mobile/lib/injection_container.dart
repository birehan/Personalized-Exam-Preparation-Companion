import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:skill_bridge_mobile/features/bookmarks/domain/usecases/bookmark_question_usecase.dart';
import 'package:skill_bridge_mobile/features/bookmarks/domain/usecases/delete_bookmarked_content.dart';
import 'package:skill_bridge_mobile/features/bookmarks/domain/usecases/delete_bookmarked_question_usecase.dart';
import 'package:skill_bridge_mobile/features/bookmarks/presentation/bloc/addContentBookmarkBloc/add_content_bookmark_bloc_bloc.dart';
import 'package:skill_bridge_mobile/features/bookmarks/presentation/bloc/bookmarksBoc/bookmarks_bloc_bloc.dart';
import 'package:skill_bridge_mobile/features/bookmarks/presentation/bloc/deleteContentBookmark/delete_content_bookmark_bloc.dart';
import 'package:skill_bridge_mobile/features/profile/domain/usecases/change_user_avatar_usecase.dart';
import 'package:skill_bridge_mobile/features/profile/domain/usecases/get_top_users_usecase.dart';
import 'package:skill_bridge_mobile/features/question/domain/usecases/get_end_chapter_questions_usecase.dart';
import 'package:skill_bridge_mobile/features/question/presentation/bloc/endOfChaptersQuestionsBloc/endof_chapter_questions_bloc.dart';
import 'package:skill_bridge_mobile/features/profile/domain/usecases/change_password_usercase.dart';
import 'package:skill_bridge_mobile/features/profile/domain/usecases/change_username_usecase.dart';
import 'package:skill_bridge_mobile/features/profile/presentation/bloc/changePasswordBloc/password_bloc.dart';
import 'package:skill_bridge_mobile/features/profile/presentation/bloc/changeUsernameBloc/username_bloc.dart';

import 'features/bookmarks/data/data.dart';
import 'features/bookmarks/domain/domain.dart';
import 'package:skill_bridge_mobile/features/profile/presentation/bloc/userProfile/userProfile_bloc.dart';
import 'features/bookmarks/presentation/bloc/addQuestionBookmarkBloc/add_question_bookmark_bloc.dart';
import 'features/bookmarks/presentation/bloc/deleteQuestionBookmarkBloc/delete_question_bookmark_bloc.dart';
import 'features/course/presentation/bloc/course/course_bloc.dart';
import 'features/profile/presentation/bloc/logout/logout_bloc.dart';

import 'core/core.dart';
import 'features/features.dart';
import 'features/profile/presentation/bloc/usersLeaderboard/users_leaderboard_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  //! Features
  //! Feature_#1 Authentication ----------------------------

  // Bloc
  serviceLocator.registerFactory(
    () => AuthenticationBloc(
      signupUsecase: serviceLocator(),
      loginUsecase: serviceLocator(),
      logoutUsecase: serviceLocator(),
      forgetPasswordUsecase: serviceLocator(),
      changePasswordUsecase: serviceLocator(),
      initializeAppUsecase: serviceLocator(),
      getAppInitializationUsecase: serviceLocator(),
      resendOtpVerificationUsecase: serviceLocator(),
      sendOtpVerificationUsecase: serviceLocator(),
      signInWithGoogleUsecase: serviceLocator(),
      signOutWithGoogleUsecase: serviceLocator(),
      getSignInWithGoogleUsecase: serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => SignupFormBloc(),
  );
  serviceLocator.registerFactory(
    () => ChangePasswordFormBloc(),
  );
  serviceLocator.registerFactory(
    () => GetUserBloc(
      getUserCredentialUsecase: serviceLocator(),
    ),
  );

  // Usecase
  serviceLocator
      .registerLazySingleton(() => SignupUsecase(repository: serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => LoginUsecase(repository: serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => LogoutUsecase(repository: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => ForgetPasswordUsecase(repository: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => ChangePasswordUsecase(repository: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => SendOtpVerificationUsecase(repository: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => ResendOtpVerificationUsecase(repository: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => InitializeAppUsecase(repository: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => GetAppInitializationUsecase(repository: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => GetUserCredentialUsecase(repository: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => SignInWithGoogleUsecase(repository: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => SignOutWithGoogleUsecase(repository: serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => GetSignInWithGoogleUsecase(repository: serviceLocator()));

  // Repository
  serviceLocator.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepositoryImpl(
      remoteDatasource: serviceLocator(),
      localDatasource: serviceLocator(),
      networkInfo: serviceLocator(),
    ),
  );

  // DataSource
  serviceLocator.registerLazySingleton<AuthenticationLocalDatasource>(
    () => AuthenticationLocalDatasourceImpl(
      flutterSecureStorage: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton<AuthenticationRemoteDatasource>(
    () => AuthenticationRemoteDatasourceImpl(
      client: serviceLocator(),
    ),
  );

  //! Feature_#2 Home ----------------------------------------

  // Bloc
  serviceLocator.registerFactory(
    () => HomeBloc(
      getMyCoursesUsecase: serviceLocator(),
      getHomeUsecase: serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => GetExamDateBloc(
      getExamDateUsecase: serviceLocator(),
    ),
  );

  // Usecase
  serviceLocator.registerLazySingleton(
    () => GetMyCoursesUsecase(
      serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => GetExamDateUsecase(
      serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => GetHomeUsecase(
      repository: serviceLocator(),
    ),
  );

  // Repository
  serviceLocator.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(
      localDatasource: serviceLocator(),
      remoteDatasource: serviceLocator(),
      networkInfo: serviceLocator(),
    ),
  );

  // Datasource
  serviceLocator.registerLazySingleton<HomeLocalDatasource>(
    () => HomeLocalDatasourceImpl(),
  );
  serviceLocator.registerLazySingleton<HomeRemoteDatasource>(
    () => HomeRemoteDatasourceImpl(
      client: serviceLocator(),
      flutterSecureStorage: serviceLocator(),
    ),
  );

  //! Feature_#3 Department -------------------------------

  // bloc
  serviceLocator.registerFactory(
    () => DepartmentBloc(
      getAllGeneralDepartmentUsecase: serviceLocator(),
    ),
  );

  // usecase
  serviceLocator.registerLazySingleton(
    () => GetAllGeneralDepartmentUsecase(
      repository: serviceLocator(),
    ),
  );

  // repository
  serviceLocator.registerLazySingleton<DepartmentRepository>(
    () => DepartmentRepositoryImpl(
      remoteDatasource: serviceLocator(),
      localDatasource: serviceLocator(),
      networkInfo: serviceLocator(),
    ),
  );

  // datasource
  serviceLocator.registerLazySingleton<DepartmentRemoteDatasource>(
    () => DepartmentRemoteDatasourceImpl(
      client: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton<DepartmentLocalDatasource>(
    () => DepartmentLocaDatasourceImpl(),
  );

  //! Feature_#4 CourseDetail and Option ---------------------

  // Bloc
  serviceLocator.registerFactory(
    () => CourseWithUserAnalysisBloc(
      getCourseUsecase: serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => SelectCourseBloc(
      getCoursesByDepartmentIdUseCase: serviceLocator(),
    ),
  );
  serviceLocator.registerFactory<DepartmentCourseBloc>(
    () => DepartmentCourseBloc(
      getDepartmentCourseUsecase: serviceLocator(),
    ),
  );
  // serviceLocator.registerFactory(
  //   () => CourseBloc(),
  // );
  serviceLocator.registerFactory(
    () => ChatWithContentBloc(
      chatUsecase: serviceLocator(),
    ),
  );
  serviceLocator.registerSingleton<CourseBloc>(
    CourseBloc(),
  );

  // Usecase
  serviceLocator.registerLazySingleton(
    () => GetCourseWithAnalysisUsecase(
      serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => GetCoursesByDepartmentIdUseCase(
      courseRepositories: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => GetDepartmentCourseUsecase(
      repository: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => ChatWithContentUsecase(
      repository: serviceLocator(),
    ),
  );

  // Repository
  serviceLocator.registerLazySingleton<CourseRepositories>(
    () => CourseRepositoryImpl(
      networkInfo: serviceLocator(),
      remoteDataSource: serviceLocator(),
    ),
  );

  // Datasource
  serviceLocator.registerLazySingleton<CourseRemoteDataSource>(
    () => CourseRemoteDataSourceImpl(
      client: serviceLocator(),
      flutterSecureStorage: serviceLocator(),
    ),
  );

  //! Feature_#5 UserCourses
  //bloc
  //! Feature 4 UserCourses ------------------------
  serviceLocator.registerFactory(
    () => UserCoursesBloc(
      userCoursesUsecase: serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => SelectDepartmentBloc(
      getAllGeneralDepartmentUsecase: serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => RegisterCourseBloc(registerCourseUsecase: serviceLocator()),
  );
  serviceLocator.registerFactory(
    () =>
        SubChapterRegstrationBloc(registerSubChapterUsecase: serviceLocator()),
  );
  // Usecase
  serviceLocator.registerLazySingleton(
    () => UserCoursesUseCase(courseRepositories: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => RegisterSubChapterUsecase(courseRepositories: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => RegisterCourseUsecase(courseRepositories: serviceLocator()),
  );

  //! Feature_#6 Search

  // Bloc
  serviceLocator.registerFactory(
    () => SearchCourseBloc(
      searchCoursesUsecase: serviceLocator(),
    ),
  );

  // Usecase
  serviceLocator.registerLazySingleton(
    () => SearchCoursesUsecase(
      serviceLocator(),
    ),
  );

  // Repository
  serviceLocator.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(
      networkInfo: serviceLocator(),
      remoteDataSource: serviceLocator(),
    ),
  );

  // Datasource
  serviceLocator.registerLazySingleton<SearchCourseRemoteDataSource>(
    () => SearchCourseRemoteDataSourceImpl(
      client: serviceLocator(),
      flutterSecureStorage: serviceLocator(),
    ),
  );

  //! Feature_#6 Mock Exam

  // Bloc
  serviceLocator.registerFactory(
    () => MockExamBloc(
      getDepartmentMocksUsecase: serviceLocator(),
      getMockExamsUsecase: serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => MyMocksBloc(
      getMyMocksUsecase: serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => MockQuestionBloc(
      getMockExamByIdUsecase: serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => UserMockBloc(
      addMockToUserMocksUsecase: serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => UpsertMockScoreBloc(
      upsertMockScoreUsecase: serviceLocator(),
    ),
  );

  // Usecase
  serviceLocator.registerLazySingleton(
    () => GetMockExamsUsecase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => GetMockExamByIdUsecase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => GetDepartmentMocksUsecase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => UpsertMockScoreUsecase(
      serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => GetMyMocksUsecase(
      serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => AddMockToUserMocksUsecase(
      serviceLocator(),
    ),
  );

  // repository
  serviceLocator.registerLazySingleton<MockExamRepository>(
    () => MockExamRepositoryImpl(
      remoteDatasource: serviceLocator(),
      localDatasource: serviceLocator(),
      networkInfo: serviceLocator(),
    ),
  );

  // datasource
  serviceLocator.registerLazySingleton<MockExamLocalDatasource>(
    () => MockExamLocalDatasourceImpl(),
  );
  serviceLocator.registerLazySingleton<MockExamRemoteDatasource>(
    () => MockExamRemoteDatasourceImpl(
      client: serviceLocator(),
      flutterSecureStorage: serviceLocator(),
    ),
  );

  //! Feature #7 - Question

  // Bloc
  serviceLocator.registerFactory(
    () => QuestionBloc(
      submitUserAnswerUsecase: serviceLocator(),
      getEndSubtopicQuestionUsecase: serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => EndofChapterQuestionsBloc(
        getEndOfChapterQuestionsUsecase: serviceLocator()),
  );
  serviceLocator.registerFactory(
    () => PopupMenuBloc(),
  );

  // Usecases
  serviceLocator.registerLazySingleton(
    () => SubmitUserAnswerUsecase(
      serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => GetEndOfChapterQuestionsUsecase(repository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => GetEndSubtopicQuestionUsecase(
      serviceLocator(),
    ),
  );
  // Repository
  serviceLocator.registerLazySingleton<QuestionRepository>(
    () => QuestionRepositoryImpl(
      localDatasource: serviceLocator(),
      remoteDatasource: serviceLocator(),
      networkInfo: serviceLocator(),
    ),
  );

  // Datasource
  serviceLocator.registerLazySingleton<QuestionLocalDatasource>(
    () => QuestionLocalDatasourceImpl(),
  );
  serviceLocator.registerLazySingleton<QuestionRemoteDatasource>(
    () => QuestionRemoteDatasourceImpl(
      client: serviceLocator(),
      flutterSecureStorage: serviceLocator(),
    ),
  );

  //! Feature 8 Chapter------------------------------

  serviceLocator.registerFactory(
    () => ChapterBloc(
      getSubchaptersListUsecase: serviceLocator(),
      getChapterByCourseIdUsecase: serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => SubChapterBloc(getContentOfSubChapterUsecase: serviceLocator()),
  );
  // Usecase
  serviceLocator.registerLazySingleton(
    () => GetContentOfSubChapterUsecase(chapterRepository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => GetSubChaptersListUsecase(chapterRepository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => GetChapterByCourseIdUsecase(serviceLocator()),
  );

  // Repository
  serviceLocator.registerLazySingleton<ChapterRepository>(
    () => ChapterRepositoryImpl(
      networkInfo: serviceLocator(),
      chapterRemoteDatasource: serviceLocator(),
    ),
  );

  // Datasource
  serviceLocator.registerLazySingleton<ChapterRemoteDatasource>(
    () => ChapterRemoteDataSourceImpl(
      flutterSecureStorage: serviceLocator(),
      client: serviceLocator(),
    ),
  );

  //! Feature 9 Quiz

  // Bloc
  serviceLocator.registerFactory(
    () => QuizBloc(
      getUserQuizUsecase: serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => QuizCreateBloc(
      createQuizUsecase: serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => QuizQuestionBloc(
      getQuizByIdUsecase: serviceLocator(),
      saveQuizScoreUsecase: serviceLocator(),
    ),
  );

  // Usecase
  serviceLocator.registerLazySingleton(
    () => GetUserQuizUsecase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => CreateQuizUsecase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => GetQuizByIdUsecase(serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => SaveQuizScoreUsecase(serviceLocator()),
  );

  // Repository
  serviceLocator.registerLazySingleton<QuizRepository>(
    () => QuizRepositoryImpl(
      remoteDataSource: serviceLocator(),
      networkInfo: serviceLocator(),
    ),
  );

  // Datasource
  serviceLocator.registerLazySingleton<QuizRemoteDataSource>(
    () => QuizRemoteDataSourceImpl(
      client: serviceLocator(),
      flutterSecureStorage: serviceLocator(),
    ),
  );
  // Datasource
  serviceLocator.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(
      flutterSecureStorage: serviceLocator(),
      client: serviceLocator(),
    ),
  );

  //! Feature 10 Proifle
  serviceLocator.registerFactory(
    () => LogoutBloc(
      logoutUsecase: serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => UsersLeaderboardBloc(getTopUsersUsecase: serviceLocator()),
  );
  // Usecase
  serviceLocator.registerLazySingleton(
    () => ProfileLogoutUsecase(profileRepositories: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => GetTopUsersUsecase(profileRepositories: serviceLocator()),
  );
  // Repository
  serviceLocator.registerLazySingleton<ProfileRepositories>(
    () => ProfileRepositoryImpl(
      profileLocalDataSource: serviceLocator(),
      profileRemoteDataSource: serviceLocator(),
      networkInfo: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton<ProfileLocalDataSource>(
    () => ProfileLocalDataSourceImpl(flutterSecureStorage: serviceLocator()),
  );

  //! Feature 11 Chat
  // bloc
  serviceLocator.registerFactory(
    () => ChatBloc(
      chatUsecase: serviceLocator(),
    ),
  );

  // usecase
  serviceLocator.registerLazySingleton(() => ChatUsecase(
        repository: serviceLocator(),
      ));
  //! Feature 11 Feedback
  serviceLocator.registerFactory(
    () => FeedbackBloc(
      submitContentFeedbackUsecase: serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => QuestionVoteBloc(
      voteQuestionUsecase: serviceLocator(),
    ),
  );

  // Usecase
  serviceLocator.registerLazySingleton(
    () => SubmitContentFeedbackUsecase(feedbackRepositories: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => VoteQuestionUsecase(
      feedbackRepositories: serviceLocator(),
    ),
  );
  // Repository
  serviceLocator.registerLazySingleton<FeedbackRepositories>(
    () => FeedbackRepositoriesImpl(
      feedbackRemoteDataSource: serviceLocator(),
      networkInfo: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton<FeedbackRemoteDataSource>(
    () => FeedbackRemoteDataSourceImpl(
      client: serviceLocator(),
      flutterSecureStorage: serviceLocator(),
    ),
  );

  //! Feature 12 Onboarding
  //bloc
  serviceLocator.registerFactory(
    () => OnboardingBloc(submitOnbardingQuestionsUsecase: serviceLocator()),
  );
  //usecase
  serviceLocator.registerLazySingleton(
    () => SubmitOnbardingQuestionsUsecase(
        onboardingQuestionsRepository: serviceLocator()),
  );
  //repository
  serviceLocator.registerLazySingleton<OnboardingQuestionsRepository>(
    () => OnboardingQuestionsRepositoryImpl(
      authLocalDatasource: serviceLocator(),
      networkInfo: serviceLocator(),
      remoteDatasource: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton<OnboardingQuestionsRemoteDataSource>(
    () => OnboardingQuestionsRemoteDataSourceImpl(
      client: serviceLocator(),
      flutterSecureStorage: serviceLocator(),
    ),
  );
  //! feature 13 bookmarking
  //bloc
  serviceLocator.registerFactory(
    () => BookmarksBlocBloc(getUserBookmarksUsecase: serviceLocator()),
  );
  serviceLocator.registerFactory(
    () => DeleteContentBookmarkBloc(
        deleteContentBookmarkUsecase: serviceLocator()),
  );
  serviceLocator.registerFactory(
    () => AddContentBookmarkBlocBloc(contentBookmarkUsecase: serviceLocator()),
  );
  serviceLocator.registerFactory(
      () => AddQuestionBookmarkBloc(questionBookmarkUsecase: serviceLocator()));
  serviceLocator.registerFactory(() => DeleteQuestionBookmarkBloc(
      deleteQuestionBookmarkUsecase: serviceLocator()));
  //usecase
  serviceLocator.registerLazySingleton(
    () => GetUserBookmarksUsecase(bookmarkRepositories: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => DeleteContentBookmarkUsecase(bookmarkRepositories: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => ContentBookmarkUsecase(bookmarkRepositories: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => DeleteQuestionBookmarkUsecase(bookmarkRepositories: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => QuestionBookmarkUsecase(bookmarkRepositories: serviceLocator()),
  );
  //repository
  serviceLocator.registerLazySingleton<BookmarkRepositories>(
    () => BookmarksReposirotyImpl(
      bookmarksRemoteDatasource: serviceLocator(),
      networkInfo: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton<BookmarksRemoteDatasource>(
      () => BookmarksRemoteDatasourceImpl(
            client: serviceLocator(),
            flutterSecureStorage: serviceLocator(),
          ));
  // feature 13 profile page
  //bloc
  serviceLocator.registerFactory(
    () => UserProfileBloc(getProfileUsecase: serviceLocator()),
  );

  //usecase
  serviceLocator.registerLazySingleton(
    () => GetProfileUsecase(profileRepositories: serviceLocator()),
  );

  // //repository
  // serviceLocator.registerLazySingleton<UserProfileRepositories>(
  //   () => UserProfileRepositoryImpl(
  //     networkInfo: serviceLocator(),
  //     userProfileRemoteDataSource: serviceLocator(),
  //   ),
  // );

  // // Datasource
  // serviceLocator.registerLazySingleton<UserProfileRemoteDataSource>(
  //   () => UserProfileRemoteDataSourceImpl(
  //     client: serviceLocator(),
  //     flutterSecureStorage: serviceLocator(),
  //   ),
  // );

  //! Feature AlertDialog
  serviceLocator.registerFactory(
    () => AlertDialogBloc(),
  );

  // feature 16 Change Password and Change Username
  //bloc
  serviceLocator.registerFactory(
    () => UsernameBloc(
        changeUsernameUsecase: serviceLocator(),
        changeUserAvatarUsecase: serviceLocator()),
  );

  serviceLocator.registerFactory(
    () => PasswordBloc(changePasswordusecase: serviceLocator()),
  );

  //usecase
  serviceLocator.registerLazySingleton(
    () => ChangeUsernameUsecase(profileRepositories: serviceLocator()),
  );

  serviceLocator.registerLazySingleton(
    () => ChangePasswordusecase(profileRepositories: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => ChangeUserAvatarUsecase(profileRepositories: serviceLocator()),
  );
  // //repository
  // serviceLocator.registerLazySingleton<ChangeUsernameRepositories>(
  //   () => ChangeUsernameRepositoriesImpl(
  //     networkInfo: serviceLocator(),
  //     changeUsernameRemoteDataSource: serviceLocator(),
  //     profileLocalDataSource: serviceLocator(),

  //   ),
  // );

  // serviceLocator.registerLazySingleton<ChangePasswordRepositories>(
  //   () => ChangePasswordRepositoriesImpl(
  //     networkInfo: serviceLocator(),
  //     changePasswordRemoteDataSource: serviceLocator(),
  //   ),
  // );

  // // Datasource
  // serviceLocator.registerLazySingleton<ChangeUsernameRemoteDataSource>(
  //   () => ChangeUsernameRemoteDataSourceImpl(
  //     client: serviceLocator(),
  //     flutterSecureStorage: serviceLocator(),
  //   ),
  // );

  // serviceLocator.registerLazySingleton<ChangePasswordRemoteDataSource>(
  //   () => ChangePasswordRemoteDataSourceImpl(
  //     client: serviceLocator(),
  //     flutterSecureStorage: serviceLocator(),
  //   ),
  // );

  //! Core ----------------------------------
  serviceLocator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(
        internetConnectionChecker: serviceLocator(),
      ));

  //! External-----------------------------------
  const flutterSecureStorage = FlutterSecureStorage();
  serviceLocator.registerFactory(() => flutterSecureStorage);

  serviceLocator.registerLazySingleton(() => http.Client());
  serviceLocator.registerLazySingleton(() => InternetConnectionChecker());
}
