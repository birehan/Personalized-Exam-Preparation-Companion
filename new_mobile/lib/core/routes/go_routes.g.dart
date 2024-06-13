// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'go_routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $onboardingPagesRoute,
      $loginPageRoute,
      $signupPageRoute,
      $onboardingQuestionPagesRoute,
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

RouteBase get $onboardingQuestionPagesRoute => GoRouteData.$route(
      path: '/onboarding-questions',
      name: 'onboardingQuestions',
      factory: $OnboardingQuestionPagesRouteExtension._fromState,
    );

extension $OnboardingQuestionPagesRouteExtension
    on OnboardingQuestionPagesRoute {
  static OnboardingQuestionPagesRoute _fromState(GoRouterState state) =>
      OnboardingQuestionPagesRoute();

  String get location => GoRouteData.$location(
        '/onboarding-questions',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $cubeAnimationPageRoute => GoRouteData.$route(
      path: '/cube-animation',
      name: 'transisitionPage',
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
          path: 'searchCourses',
          name: 'searchCourses',
          factory: $SearchCoursesPageRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'my-courses',
          name: 'myCourses',
          factory: $MyCoursesPageRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'choose-subject',
          name: 'chooseSubject',
          factory: $ChooseSubjectPageRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'exams',
          name: 'examsPage',
          factory: $ExamsPageRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'mockSubject',
          name: 'mockSubject',
          factory: $ChooseMockSubjectPageRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: 'university-exams',
              name: 'universityExamPage',
              factory: $UniversityMockExamPageRouteExtension._fromState,
              routes: [
                GoRouteData.$route(
                  path: 'universityMockExamDetailPage',
                  name: 'universityMockExamDetailPage',
                  factory: $UniversityMockExamDetailPageExtension._fromState,
                  routes: [
                    GoRouteData.$route(
                      path: 'university-mock-question-page',
                      name: 'universityMockQuestionPage',
                      factory: $UniversityMockExamsQuestionPageRouteExtension
                          ._fromState,
                      routes: [
                        GoRouteData.$route(
                          path: 'chat',
                          name: 'mocksChatPage',
                          factory: $MocksChatWithApiRouteExtension._fromState,
                        ),
                        GoRouteData.$route(
                          path: 'content',
                          name: 'contentFromMock',
                          factory: $MockToContentPageRouteExtension._fromState,
                        ),
                      ],
                    ),
                    GoRouteData.$route(
                      path: 'standard-mock-result',
                      name: 'standardMockResult',
                      factory: $StandardMockResultPageRouteExtension._fromState,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        GoRouteData.$route(
          path: 'my-exams',
          name: 'myExamsPage',
          factory: $MyExamsPageRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: 'userMockExamDetailPage',
              name: 'userMockExamDetailPage',
              factory: $MyExamsMockDetailPageRouteExtension._fromState,
              routes: [
                GoRouteData.$route(
                  path: 'userMockQuestionPage',
                  name: 'userMockQuestionPage',
                  factory: $MyExamsMockQuestionPageRouteExtension._fromState,
                  routes: [
                    GoRouteData.$route(
                      path: 'userMockChat',
                      name: 'userMockChatPage',
                      factory: $UserMocksChatWithApiRouteExtension._fromState,
                    ),
                    GoRouteData.$route(
                      path: 'userMockContent',
                      name: 'userMockContentFromMock',
                      factory: $UserMockToContentPageRouteExtension._fromState,
                    ),
                  ],
                ),
                GoRouteData.$route(
                  path: 'standard-mock-result',
                  name: 'myStandardMockResult',
                  factory: $MyMockExamResultPageRouteExtension._fromState,
                ),
              ],
            ),
          ],
        ),
        GoRouteData.$route(
          path: 'downloadedMockExamsPage',
          name: 'downloadedMockExamsPage',
          factory: $DownloadedMockExamsPageRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: 'downloadedMockExamQuestionPage',
              name: 'downloadedMockExamQuestionPage',
              factory: $DownloadedMockExamQuestionPageRouteExtension._fromState,
            ),
            GoRouteData.$route(
              path: 'downloadedMockResultPage',
              name: 'downloadedMockResultPage',
              factory: $DownloadedMockResultPageRouteExtension._fromState,
            ),
          ],
        ),
        GoRouteData.$route(
          path: 'profile',
          name: 'profile',
          factory: $UpdatedProfilePageRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: 'editProfile',
              factory: $EditProfilePageRouteExtension._fromState,
            ),
            GoRouteData.$route(
              path: 'friends',
              name: 'friends',
              factory: $FriendsMainPageRouteExtension._fromState,
              routes: [
                GoRouteData.$route(
                  path: 'editProfile',
                  factory: $AddFriendspageRouteExtension._fromState,
                ),
              ],
            ),
          ],
        ),
        GoRouteData.$route(
          path: 'leaderoard',
          name: 'leaderboard',
          factory: $UserLeaderboardPageRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'leaderboardDetail',
          name: 'leaderboardDetail',
          factory: $LeaderboardDetailPageRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'bookmarkedContent',
          name: 'bookmarkedContent',
          factory: $BookmarkedContentPageRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'bookmarkedQuestion',
          name: 'bookmarkedQuestion',
          factory: $BookmarkedQuestionPageRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: 'content/:courseId',
              name: 'bookmarkContent',
              factory:
                  $BookmarkedQuestionRelatedTopicPageRouteExtension._fromState,
            ),
          ],
        ),
        GoRouteData.$route(
          path: 'course/:courseId',
          name: 'courseDetail',
          factory: $CourseDetailPageRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: 'endOfChapterPage',
              name: 'endOfChapterpage',
              factory: $EndOfChapterPageRouteExtension._fromState,
            ),
            GoRouteData.$route(
              path: 'quiz',
              name: 'createQuiz',
              factory: $CreateQuizPageRouteExtension._fromState,
            ),
            GoRouteData.$route(
              path: 'content/:subChapterId',
              name: 'contentReadonly',
              factory: $ContentPageRouteExtension._fromState,
              routes: [
                GoRouteData.$route(
                  path: 'chat',
                  name: 'chatWithContent',
                  factory: $ChatWithContentPageRouteExtension._fromState,
                ),
              ],
            ),
            GoRouteData.$route(
              path: 'quiz/:quizId',
              name: 'newQuizQuestionPage',
              factory: $QuizQuestionPageRouteExtension._fromState,
              routes: [
                GoRouteData.$route(
                  path: 'chat/:questionId',
                  name: 'chatWithAI',
                  factory: $QuizChatWithAIPageRouteExtension._fromState,
                ),
                GoRouteData.$route(
                  path: 'content',
                  name: 'contentFromQuiz',
                  factory: $QuizContentPageRouteExtension._fromState,
                ),
              ],
            ),
            GoRouteData.$route(
              path: 'quiz-result-page',
              name: 'quizResultPageRoute',
              factory: $QuizResultPageRouteExtension._fromState,
            ),
            GoRouteData.$route(
              path: 'endOfChapterQuestions',
              name: 'endOfChapterQuestions',
              factory: $EndOfChapterQuestionsPageRouteExtension._fromState,
            ),
            GoRouteData.$route(
              path: 'endOfSubchapter',
              name: 'endOfSubchapter',
              factory: $EndOfSubChapterQuestionsPageRouteExtension._fromState,
            ),
            GoRouteData.$route(
              path: 'endOfQuestionsResult',
              name: 'endOfQuestionsResult',
              factory: $EndOfQuestionsResultPageRouteExtension._fromState,
            ),
            GoRouteData.$route(
              path: 'videoPlayerPage',
              name: 'videoPlayerPage',
              factory: $VideoPlayerPageRouteExtension._fromState,
            ),
          ],
        ),
        GoRouteData.$route(
          path: 'downloadedCourseDetailPage',
          name: 'downloadedCourseDetailPage',
          factory: $DownloadedCourseDetailPageRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: 'downloadedContentPage/:chapterIdx/:subChapterIdx',
              name: 'downloadedContentPage',
              factory: $DownloadedContentPageRouteExtension._fromState,
            ),
          ],
        ),
        GoRouteData.$route(
          path: 'recommended-mock-result',
          name: 'recommendedMockResult',
          factory: $RecommendedMockResultPageRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: 'contest/:id',
          name: 'contestDetail',
          factory: $ContestDetailPageRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: 'categoryQuestions',
              name: 'contestQuestionByCategory',
              factory: $ContestQuestionByCategoryPageRouteExtension._fromState,
              routes: [
                GoRouteData.$route(
                  path: 'content',
                  name: 'contestContent',
                  factory: $ContestToContentPageRouteExtension._fromState,
                ),
                GoRouteData.$route(
                  path: 'chat',
                  name: 'contestChatWithAI',
                  factory:
                      $ContestQuestionByCategoryChatWithAIPageRouteExtension
                          ._fromState,
                ),
              ],
            ),
          ],
        ),
        GoRouteData.$route(
          path: 'dailyQuiz',
          name: 'dailyQuizQuestionPage',
          factory: $DailyQuizQuestionPageRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: 'content',
              name: 'dailyQuizContent',
              factory: $DailyQuizContentPageRouteExtension._fromState,
            ),
            GoRouteData.$route(
              path: 'chat',
              name: 'dailyQuizChatWithAI',
              factory:
                  $DailyQuizQuestionChatWithAIPageRouteExtension._fromState,
            ),
          ],
        ),
        GoRouteData.$route(
          path: 'shared-question-page/:questionId',
          name: 'Shared Question Page',
          factory: $SharedQuestionPageRouteExtension._fromState,
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

extension $SearchCoursesPageRouteExtension on SearchCoursesPageRoute {
  static SearchCoursesPageRoute _fromState(GoRouterState state) =>
      SearchCoursesPageRoute();

  String get location => GoRouteData.$location(
        '/searchCourses',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $MyCoursesPageRouteExtension on MyCoursesPageRoute {
  static MyCoursesPageRoute _fromState(GoRouterState state) =>
      MyCoursesPageRoute();

  String get location => GoRouteData.$location(
        '/my-courses',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ChooseSubjectPageRouteExtension on ChooseSubjectPageRoute {
  static ChooseSubjectPageRoute _fromState(GoRouterState state) =>
      ChooseSubjectPageRoute(
        $extra: state.extra as bool?,
      );

  String get location => GoRouteData.$location(
        '/choose-subject',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

extension $ExamsPageRouteExtension on ExamsPageRoute {
  static ExamsPageRoute _fromState(GoRouterState state) => ExamsPageRoute();

  String get location => GoRouteData.$location(
        '/exams',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ChooseMockSubjectPageRouteExtension on ChooseMockSubjectPageRoute {
  static ChooseMockSubjectPageRoute _fromState(GoRouterState state) =>
      ChooseMockSubjectPageRoute(
        isStandard: _$boolConverter(state.queryParameters['is-standard']!),
      );

  String get location => GoRouteData.$location(
        '/mockSubject',
        queryParams: {
          'is-standard': isStandard.toString(),
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $UniversityMockExamPageRouteExtension on UniversityMockExamPageRoute {
  static UniversityMockExamPageRoute _fromState(GoRouterState state) =>
      UniversityMockExamPageRoute(
        courseImage: state.queryParameters['course-image']!,
        courseName: state.queryParameters['course-name']!,
        isStandard: _$boolConverter(state.queryParameters['is-standard']!),
      );

  String get location => GoRouteData.$location(
        '/mockSubject/university-exams',
        queryParams: {
          'course-image': courseImage,
          'course-name': courseName,
          'is-standard': isStandard.toString(),
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $UniversityMockExamDetailPageExtension
    on UniversityMockExamDetailPage {
  static UniversityMockExamDetailPage _fromState(GoRouterState state) =>
      UniversityMockExamDetailPage(
        courseImage: state.queryParameters['course-image']!,
        courseName: state.queryParameters['course-name']!,
        isStandard: _$boolConverter(state.queryParameters['is-standard']!),
        mockId: state.queryParameters['mock-id']!,
      );

  String get location => GoRouteData.$location(
        '/mockSubject/university-exams/universityMockExamDetailPage',
        queryParams: {
          'course-image': courseImage,
          'course-name': courseName,
          'is-standard': isStandard.toString(),
          'mock-id': mockId,
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $UniversityMockExamsQuestionPageRouteExtension
    on UniversityMockExamsQuestionPageRoute {
  static UniversityMockExamsQuestionPageRoute _fromState(GoRouterState state) =>
      UniversityMockExamsQuestionPageRoute(
        courseImage: state.queryParameters['course-image']!,
        courseName: state.queryParameters['course-name']!,
        isStandard: _$boolConverter(state.queryParameters['is-standard']!),
        mockId: state.queryParameters['mock-id']!,
        $extra: state.extra as MockExamQuestionPageParams,
      );

  String get location => GoRouteData.$location(
        '/mockSubject/university-exams/universityMockExamDetailPage/university-mock-question-page',
        queryParams: {
          'course-image': courseImage,
          'course-name': courseName,
          'is-standard': isStandard.toString(),
          'mock-id': mockId,
        },
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

extension $MocksChatWithApiRouteExtension on MocksChatWithApiRoute {
  static MocksChatWithApiRoute _fromState(GoRouterState state) =>
      MocksChatWithApiRoute(
        question: state.queryParameters['question']!,
        questionId: state.queryParameters['question-id']!,
        isStandard: _$boolConverter(state.queryParameters['is-standard']!),
        courseImage: state.queryParameters['course-image']!,
        courseName: state.queryParameters['course-name']!,
        mockId: state.queryParameters['mock-id']!,
        $extra: state.extra as MockExamQuestionPageParams,
      );

  String get location => GoRouteData.$location(
        '/mockSubject/university-exams/universityMockExamDetailPage/university-mock-question-page/chat',
        queryParams: {
          'question': question,
          'question-id': questionId,
          'is-standard': isStandard.toString(),
          'course-image': courseImage,
          'course-name': courseName,
          'mock-id': mockId,
        },
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

extension $MockToContentPageRouteExtension on MockToContentPageRoute {
  static MockToContentPageRoute _fromState(GoRouterState state) =>
      MockToContentPageRoute(
        courseId: state.queryParameters['course-id']!,
        isStandard: _$boolConverter(state.queryParameters['is-standard']!),
        courseImage: state.queryParameters['course-image']!,
        courseName: state.queryParameters['course-name']!,
        mockId: state.queryParameters['mock-id']!,
        $extra: state.extra as MockExamQuestionPageParams,
      );

  String get location => GoRouteData.$location(
        '/mockSubject/university-exams/universityMockExamDetailPage/university-mock-question-page/content',
        queryParams: {
          'course-id': courseId,
          'is-standard': isStandard.toString(),
          'course-image': courseImage,
          'course-name': courseName,
          'mock-id': mockId,
        },
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

extension $StandardMockResultPageRouteExtension on StandardMockResultPageRoute {
  static StandardMockResultPageRoute _fromState(GoRouterState state) =>
      StandardMockResultPageRoute(
        courseImage: state.queryParameters['course-image']!,
        courseName: state.queryParameters['course-name']!,
        isStandard: _$boolConverter(state.queryParameters['is-standard']!),
        $extra: state.extra as ResultPageParams,
      );

  String get location => GoRouteData.$location(
        '/mockSubject/university-exams/universityMockExamDetailPage/standard-mock-result',
        queryParams: {
          'course-image': courseImage,
          'course-name': courseName,
          'is-standard': isStandard.toString(),
        },
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

extension $MyExamsPageRouteExtension on MyExamsPageRoute {
  static MyExamsPageRoute _fromState(GoRouterState state) => MyExamsPageRoute();

  String get location => GoRouteData.$location(
        '/my-exams',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $MyExamsMockDetailPageRouteExtension on MyExamsMockDetailPageRoute {
  static MyExamsMockDetailPageRoute _fromState(GoRouterState state) =>
      MyExamsMockDetailPageRoute(
        mockId: state.queryParameters['mock-id']!,
      );

  String get location => GoRouteData.$location(
        '/my-exams/userMockExamDetailPage',
        queryParams: {
          'mock-id': mockId,
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $MyExamsMockQuestionPageRouteExtension
    on MyExamsMockQuestionPageRoute {
  static MyExamsMockQuestionPageRoute _fromState(GoRouterState state) =>
      MyExamsMockQuestionPageRoute(
        mockId: state.queryParameters['mock-id']!,
        $extra: state.extra as MockExamQuestionPageParams,
      );

  String get location => GoRouteData.$location(
        '/my-exams/userMockExamDetailPage/userMockQuestionPage',
        queryParams: {
          'mock-id': mockId,
        },
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

extension $UserMocksChatWithApiRouteExtension on UserMocksChatWithApiRoute {
  static UserMocksChatWithApiRoute _fromState(GoRouterState state) =>
      UserMocksChatWithApiRoute(
        question: state.queryParameters['question']!,
        questionId: state.queryParameters['question-id']!,
        mockId: state.queryParameters['mock-id']!,
        $extra: state.extra as MockExamQuestionPageParams,
      );

  String get location => GoRouteData.$location(
        '/my-exams/userMockExamDetailPage/userMockQuestionPage/userMockChat',
        queryParams: {
          'question': question,
          'question-id': questionId,
          'mock-id': mockId,
        },
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

extension $UserMockToContentPageRouteExtension on UserMockToContentPageRoute {
  static UserMockToContentPageRoute _fromState(GoRouterState state) =>
      UserMockToContentPageRoute(
        courseId: state.queryParameters['course-id']!,
        mockId: state.queryParameters['mock-id']!,
        $extra: state.extra as MockExamQuestionPageParams,
      );

  String get location => GoRouteData.$location(
        '/my-exams/userMockExamDetailPage/userMockQuestionPage/userMockContent',
        queryParams: {
          'course-id': courseId,
          'mock-id': mockId,
        },
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

extension $MyMockExamResultPageRouteExtension on MyMockExamResultPageRoute {
  static MyMockExamResultPageRoute _fromState(GoRouterState state) =>
      MyMockExamResultPageRoute(
        isStandard: _$boolConverter(state.queryParameters['is-standard']!),
        $extra: state.extra as ResultPageParams,
      );

  String get location => GoRouteData.$location(
        '/my-exams/userMockExamDetailPage/standard-mock-result',
        queryParams: {
          'is-standard': isStandard.toString(),
        },
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

extension $DownloadedMockExamsPageRouteExtension
    on DownloadedMockExamsPageRoute {
  static DownloadedMockExamsPageRoute _fromState(GoRouterState state) =>
      DownloadedMockExamsPageRoute();

  String get location => GoRouteData.$location(
        '/downloadedMockExamsPage',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $DownloadedMockExamQuestionPageRouteExtension
    on DownloadedMockExamQuestionPageRoute {
  static DownloadedMockExamQuestionPageRoute _fromState(GoRouterState state) =>
      DownloadedMockExamQuestionPageRoute(
        $extra: state.extra as DownloadedMockExamQuestionPageParams,
      );

  String get location => GoRouteData.$location(
        '/downloadedMockExamsPage/downloadedMockExamQuestionPage',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

extension $DownloadedMockResultPageRouteExtension
    on DownloadedMockResultPageRoute {
  static DownloadedMockResultPageRoute _fromState(GoRouterState state) =>
      DownloadedMockResultPageRoute(
        $extra: state.extra as ResultPageParams,
      );

  String get location => GoRouteData.$location(
        '/downloadedMockExamsPage/downloadedMockResultPage',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

extension $UpdatedProfilePageRouteExtension on UpdatedProfilePageRoute {
  static UpdatedProfilePageRoute _fromState(GoRouterState state) =>
      UpdatedProfilePageRoute();

  String get location => GoRouteData.$location(
        '/profile',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $EditProfilePageRouteExtension on EditProfilePageRoute {
  static EditProfilePageRoute _fromState(GoRouterState state) =>
      EditProfilePageRoute();

  String get location => GoRouteData.$location(
        '/profile/editProfile',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $FriendsMainPageRouteExtension on FriendsMainPageRoute {
  static FriendsMainPageRoute _fromState(GoRouterState state) =>
      FriendsMainPageRoute();

  String get location => GoRouteData.$location(
        '/profile/friends',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $AddFriendspageRouteExtension on AddFriendspageRoute {
  static AddFriendspageRoute _fromState(GoRouterState state) =>
      AddFriendspageRoute();

  String get location => GoRouteData.$location(
        '/profile/friends/editProfile',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $UserLeaderboardPageRouteExtension on UserLeaderboardPageRoute {
  static UserLeaderboardPageRoute _fromState(GoRouterState state) =>
      UserLeaderboardPageRoute();

  String get location => GoRouteData.$location(
        '/leaderoard',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $LeaderboardDetailPageRouteExtension on LeaderboardDetailPageRoute {
  static LeaderboardDetailPageRoute _fromState(GoRouterState state) =>
      LeaderboardDetailPageRoute(
        userId: state.queryParameters['user-id']!,
      );

  String get location => GoRouteData.$location(
        '/leaderboardDetail',
        queryParams: {
          'user-id': userId,
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $BookmarkedContentPageRouteExtension on BookmarkedContentPageRoute {
  static BookmarkedContentPageRoute _fromState(GoRouterState state) =>
      BookmarkedContentPageRoute(
        $extra: state.extra as BookmarkedContent,
      );

  String get location => GoRouteData.$location(
        '/bookmarkedContent',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

extension $BookmarkedQuestionPageRouteExtension on BookmarkedQuestionPageRoute {
  static BookmarkedQuestionPageRoute _fromState(GoRouterState state) =>
      BookmarkedQuestionPageRoute(
        $extra: state.extra as BookmarkedQuestions,
      );

  String get location => GoRouteData.$location(
        '/bookmarkedQuestion',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

extension $BookmarkedQuestionRelatedTopicPageRouteExtension
    on BookmarkedQuestionRelatedTopicPageRoute {
  static BookmarkedQuestionRelatedTopicPageRoute _fromState(
          GoRouterState state) =>
      BookmarkedQuestionRelatedTopicPageRoute(
        courseId: state.pathParameters['courseId']!,
        $extra: state.extra as BookmarkedQuestions,
      );

  String get location => GoRouteData.$location(
        '/bookmarkedQuestion/content/${Uri.encodeComponent(courseId)}',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

extension $CourseDetailPageRouteExtension on CourseDetailPageRoute {
  static CourseDetailPageRoute _fromState(GoRouterState state) =>
      CourseDetailPageRoute(
        courseId: state.pathParameters['courseId']!,
        lastStartedSubChapterId:
            state.queryParameters['last-started-sub-chapter-id'],
      );

  String get location => GoRouteData.$location(
        '/course/${Uri.encodeComponent(courseId)}',
        queryParams: {
          if (lastStartedSubChapterId != null)
            'last-started-sub-chapter-id': lastStartedSubChapterId,
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $EndOfChapterPageRouteExtension on EndOfChapterPageRoute {
  static EndOfChapterPageRoute _fromState(GoRouterState state) =>
      EndOfChapterPageRoute(
        courseId: state.pathParameters['courseId']!,
      );

  String get location => GoRouteData.$location(
        '/course/${Uri.encodeComponent(courseId)}/endOfChapterPage',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $CreateQuizPageRouteExtension on CreateQuizPageRoute {
  static CreateQuizPageRoute _fromState(GoRouterState state) =>
      CreateQuizPageRoute(
        courseId: state.pathParameters['courseId']!,
      );

  String get location => GoRouteData.$location(
        '/course/${Uri.encodeComponent(courseId)}/quiz',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ContentPageRouteExtension on ContentPageRoute {
  static ContentPageRoute _fromState(GoRouterState state) => ContentPageRoute(
        courseId: state.pathParameters['courseId']!,
        subChapterId: state.pathParameters['subChapterId']!,
        readOnly: _$boolConverter(state.queryParameters['read-only']!),
      );

  String get location => GoRouteData.$location(
        '/course/${Uri.encodeComponent(courseId)}/content/${Uri.encodeComponent(subChapterId)}',
        queryParams: {
          'read-only': readOnly.toString(),
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ChatWithContentPageRouteExtension on ChatWithContentPageRoute {
  static ChatWithContentPageRoute _fromState(GoRouterState state) =>
      ChatWithContentPageRoute(
        courseId: state.pathParameters['courseId']!,
        subChapterId: state.pathParameters['subChapterId']!,
        readOnly: _$boolConverter(state.queryParameters['read-only']!),
      );

  String get location => GoRouteData.$location(
        '/course/${Uri.encodeComponent(courseId)}/content/${Uri.encodeComponent(subChapterId)}/chat',
        queryParams: {
          'read-only': readOnly.toString(),
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $QuizQuestionPageRouteExtension on QuizQuestionPageRoute {
  static QuizQuestionPageRoute _fromState(GoRouterState state) =>
      QuizQuestionPageRoute(
        courseId: state.pathParameters['courseId']!,
        quizId: state.pathParameters['quizId']!,
        $extra: state.extra as QuestionMode,
      );

  String get location => GoRouteData.$location(
        '/course/${Uri.encodeComponent(courseId)}/quiz/${Uri.encodeComponent(quizId)}',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

extension $QuizChatWithAIPageRouteExtension on QuizChatWithAIPageRoute {
  static QuizChatWithAIPageRoute _fromState(GoRouterState state) =>
      QuizChatWithAIPageRoute(
        courseId: state.pathParameters['courseId']!,
        quizId: state.pathParameters['quizId']!,
        questionId: state.pathParameters['questionId']!,
        question: state.queryParameters['question']!,
        $extra: state.extra as QuestionMode,
      );

  String get location => GoRouteData.$location(
        '/course/${Uri.encodeComponent(courseId)}/quiz/${Uri.encodeComponent(quizId)}/chat/${Uri.encodeComponent(questionId)}',
        queryParams: {
          'question': question,
        },
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

extension $QuizContentPageRouteExtension on QuizContentPageRoute {
  static QuizContentPageRoute _fromState(GoRouterState state) =>
      QuizContentPageRoute(
        courseId: state.pathParameters['courseId']!,
        quizId: state.pathParameters['quizId']!,
        $extra: state.extra as QuestionMode,
      );

  String get location => GoRouteData.$location(
        '/course/${Uri.encodeComponent(courseId)}/quiz/${Uri.encodeComponent(quizId)}/content',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

extension $QuizResultPageRouteExtension on QuizResultPageRoute {
  static QuizResultPageRoute _fromState(GoRouterState state) =>
      QuizResultPageRoute(
        courseId: state.pathParameters['courseId']!,
        $extra: state.extra as ResultPageParams,
      );

  String get location => GoRouteData.$location(
        '/course/${Uri.encodeComponent(courseId)}/quiz-result-page',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

extension $EndOfChapterQuestionsPageRouteExtension
    on EndOfChapterQuestionsPageRoute {
  static EndOfChapterQuestionsPageRoute _fromState(GoRouterState state) =>
      EndOfChapterQuestionsPageRoute(
        courseId: state.pathParameters['courseId']!,
      );

  String get location => GoRouteData.$location(
        '/course/${Uri.encodeComponent(courseId)}/endOfChapterQuestions',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $EndOfSubChapterQuestionsPageRouteExtension
    on EndOfSubChapterQuestionsPageRoute {
  static EndOfSubChapterQuestionsPageRoute _fromState(GoRouterState state) =>
      EndOfSubChapterQuestionsPageRoute(
        courseId: state.pathParameters['courseId']!,
        subTopicId: state.queryParameters['sub-topic-id']!,
      );

  String get location => GoRouteData.$location(
        '/course/${Uri.encodeComponent(courseId)}/endOfSubchapter',
        queryParams: {
          'sub-topic-id': subTopicId,
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $EndOfQuestionsResultPageRouteExtension
    on EndOfQuestionsResultPageRoute {
  static EndOfQuestionsResultPageRoute _fromState(GoRouterState state) =>
      EndOfQuestionsResultPageRoute(
        courseId: state.pathParameters['courseId']!,
        $extra: state.extra as ResultPageParams,
      );

  String get location => GoRouteData.$location(
        '/course/${Uri.encodeComponent(courseId)}/endOfQuestionsResult',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

extension $VideoPlayerPageRouteExtension on VideoPlayerPageRoute {
  static VideoPlayerPageRoute _fromState(GoRouterState state) =>
      VideoPlayerPageRoute(
        courseId: state.pathParameters['courseId']!,
        videoLink: state.queryParameters['video-link']!,
        lastStartedSubChapterId:
            state.queryParameters['last-started-sub-chapter-id'],
      );

  String get location => GoRouteData.$location(
        '/course/${Uri.encodeComponent(courseId)}/videoPlayerPage',
        queryParams: {
          'video-link': videoLink,
          if (lastStartedSubChapterId != null)
            'last-started-sub-chapter-id': lastStartedSubChapterId,
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $DownloadedCourseDetailPageRouteExtension
    on DownloadedCourseDetailPageRoute {
  static DownloadedCourseDetailPageRoute _fromState(GoRouterState state) =>
      DownloadedCourseDetailPageRoute(
        $extra: state.extra as Course,
      );

  String get location => GoRouteData.$location(
        '/downloadedCourseDetailPage',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

extension $DownloadedContentPageRouteExtension on DownloadedContentPageRoute {
  static DownloadedContentPageRoute _fromState(GoRouterState state) =>
      DownloadedContentPageRoute(
        chapterIdx: int.parse(state.pathParameters['chapterIdx']!),
        subChapterIdx: int.parse(state.pathParameters['subChapterIdx']!),
        $extra: state.extra as Course,
      );

  String get location => GoRouteData.$location(
        '/downloadedCourseDetailPage/downloadedContentPage/${Uri.encodeComponent(chapterIdx.toString())}/${Uri.encodeComponent(subChapterIdx.toString())}',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

extension $RecommendedMockResultPageRouteExtension
    on RecommendedMockResultPageRoute {
  static RecommendedMockResultPageRoute _fromState(GoRouterState state) =>
      RecommendedMockResultPageRoute(
        $extra: state.extra as ResultPageParams,
      );

  String get location => GoRouteData.$location(
        '/recommended-mock-result',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

extension $ContestDetailPageRouteExtension on ContestDetailPageRoute {
  static ContestDetailPageRoute _fromState(GoRouterState state) =>
      ContestDetailPageRoute(
        id: state.pathParameters['id']!,
      );

  String get location => GoRouteData.$location(
        '/contest/${Uri.encodeComponent(id)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $ContestQuestionByCategoryPageRouteExtension
    on ContestQuestionByCategoryPageRoute {
  static ContestQuestionByCategoryPageRoute _fromState(GoRouterState state) =>
      ContestQuestionByCategoryPageRoute(
        id: state.pathParameters['id']!,
        // $extra: state.extra as ContestQuestionByCategoryPageParams,
      );

  String get location => GoRouteData.$location(
        '/contest/${Uri.encodeComponent(id)}/categoryQuestions',
      );

}

extension $ContestToContentPageRouteExtension on ContestToContentPageRoute {
  static ContestToContentPageRoute _fromState(GoRouterState state) =>
      ContestToContentPageRoute(
        id: state.pathParameters['id']!,
        courseId: state.queryParameters['course-id']!,
      );

  String get location => GoRouteData.$location(
        '/contest/${Uri.encodeComponent(id)}/categoryQuestions/content',
        queryParams: {
          'course-id': courseId,
        },
      );

}

extension $ContestQuestionByCategoryChatWithAIPageRouteExtension
    on ContestQuestionByCategoryChatWithAIPageRoute {
  static ContestQuestionByCategoryChatWithAIPageRoute _fromState(
          GoRouterState state) =>
      ContestQuestionByCategoryChatWithAIPageRoute(
        id: state.pathParameters['id']!,
        questionId: state.queryParameters['question-id']!,
        question: state.queryParameters['question']!,
      );

  String get location => GoRouteData.$location(
        '/contest/${Uri.encodeComponent(id)}/categoryQuestions/chat',
        queryParams: {
          'question-id': questionId,
          'question': question,
        },
      );

}

extension $DailyQuizQuestionPageRouteExtension on DailyQuizQuestionPageRoute {
  static DailyQuizQuestionPageRoute _fromState(GoRouterState state) =>
      DailyQuizQuestionPageRoute(
        $extra: state.extra as DailyQuestionPageParams,
      );

  String get location => GoRouteData.$location(
        '/dailyQuiz',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

extension $DailyQuizContentPageRouteExtension on DailyQuizContentPageRoute {
  static DailyQuizContentPageRoute _fromState(GoRouterState state) =>
      DailyQuizContentPageRoute(
        courseId: state.queryParameters['course-id']!,
        $extra: state.extra as DailyQuestionPageParams,
      );

  String get location => GoRouteData.$location(
        '/dailyQuiz/content',
        queryParams: {
          'course-id': courseId,
        },
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

extension $DailyQuizQuestionChatWithAIPageRouteExtension
    on DailyQuizQuestionChatWithAIPageRoute {
  static DailyQuizQuestionChatWithAIPageRoute _fromState(GoRouterState state) =>
      DailyQuizQuestionChatWithAIPageRoute(
        questionId: state.queryParameters['question-id']!,
        question: state.queryParameters['question']!,
        $extra: state.extra as DailyQuestionPageParams,
      );

  String get location => GoRouteData.$location(
        '/dailyQuiz/chat',
        queryParams: {
          'question-id': questionId,
          'question': question,
        },
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

extension $SharedQuestionPageRouteExtension on SharedQuestionPageRoute {
  static SharedQuestionPageRoute _fromState(GoRouterState state) =>
      SharedQuestionPageRoute(
        questionId: state.pathParameters['questionId']!,
      );

  String get location => GoRouteData.$location(
        '/shared-question-page/${Uri.encodeComponent(questionId)}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
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
