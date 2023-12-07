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
          path: 'my-courses',
          name: 'myCourses',
          factory: $MyCoursesPageRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: 'searchCourses',
              factory: $SearchCoursesPageRouteExtension._fromState,
            ),
          ],
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
                  path: 'mocks/:mockId',
                  name: 'generalMocks',
                  factory: $StandardMockExamsPageRouteExtension._fromState,
                  routes: [
                    GoRouteData.$route(
                      path: 'chat/:questionId',
                      name: 'standardMockChatPage',
                      factory:
                          $StandardMockChatWithAIPageRouteExtension._fromState,
                    ),
                    GoRouteData.$route(
                      path: 'content',
                      factory:
                          $StandardMockContentPageRouteExtension._fromState,
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
        GoRouteData.$route(
          path: 'my-exams',
          name: 'myExamsPage',
          factory: $MyExamsPageRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: 'mocks/:mockId',
              name: 'myMocks',
              factory: $MyMockExamPageRouteExtension._fromState,
              routes: [
                GoRouteData.$route(
                  path: 'chat/:questionId',
                  name: 'myStandardMockChatPage',
                  factory: $MyMockExamChatWithAIPageRouteExtension._fromState,
                ),
                GoRouteData.$route(
                  path: 'content',
                  factory: $MyMockExamContentPageRouteExtension._fromState,
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
              path: 'content/:readOnly',
              name: 'content',
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
                  factory: $QuizChatWithAIPageRouteExtension._fromState,
                ),
                GoRouteData.$route(
                  path: 'content',
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
          ],
        ),
        GoRouteData.$route(
          path: 'mock/:mockId',
          name: 'recommendedMock',
          factory: $RecommendedMockPageRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: 'chat/:questionId',
              name: 'recommendedMockChatPage',
              factory: $RecommendedMockChatWithAIPageRouteExtension._fromState,
            ),
            GoRouteData.$route(
              path: 'content',
              factory: $RecommendedMockContentPageRouteExtension._fromState,
            ),
          ],
        ),
        GoRouteData.$route(
          path: 'recommended-mock-result',
          name: 'recommendedMockResult',
          factory: $RecommendedMockResultPageRouteExtension._fromState,
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

extension $SearchCoursesPageRouteExtension on SearchCoursesPageRoute {
  static SearchCoursesPageRoute _fromState(GoRouterState state) =>
      SearchCoursesPageRoute();

  String get location => GoRouteData.$location(
        '/my-courses/searchCourses',
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

extension $StandardMockExamsPageRouteExtension on StandardMockExamsPageRoute {
  static StandardMockExamsPageRoute _fromState(GoRouterState state) =>
      StandardMockExamsPageRoute(
        mockId: state.pathParameters['mockId']!,
        courseImage: state.queryParameters['course-image']!,
        courseName: state.queryParameters['course-name']!,
        isStandard: _$boolConverter(state.queryParameters['is-standard']!),
        $extra: state.extra as QuestionMode,
      );

  String get location => GoRouteData.$location(
        '/mockSubject/university-exams/mocks/${Uri.encodeComponent(mockId)}',
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

extension $StandardMockChatWithAIPageRouteExtension
    on StandardMockChatWithAIPageRoute {
  static StandardMockChatWithAIPageRoute _fromState(GoRouterState state) =>
      StandardMockChatWithAIPageRoute(
        mockId: state.pathParameters['mockId']!,
        questionId: state.pathParameters['questionId']!,
        courseImage: state.queryParameters['course-image']!,
        courseName: state.queryParameters['course-name']!,
        isStandard: _$boolConverter(state.queryParameters['is-standard']!),
        question: state.queryParameters['question']!,
        $extra: state.extra as QuestionMode,
      );

  String get location => GoRouteData.$location(
        '/mockSubject/university-exams/mocks/${Uri.encodeComponent(mockId)}/chat/${Uri.encodeComponent(questionId)}',
        queryParams: {
          'course-image': courseImage,
          'course-name': courseName,
          'is-standard': isStandard.toString(),
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

extension $StandardMockContentPageRouteExtension
    on StandardMockContentPageRoute {
  static StandardMockContentPageRoute _fromState(GoRouterState state) =>
      StandardMockContentPageRoute(
        mockId: state.pathParameters['mockId']!,
        courseId: state.queryParameters['course-id']!,
        courseImage: state.queryParameters['course-image']!,
        courseName: state.queryParameters['course-name']!,
        isStandard: _$boolConverter(state.queryParameters['is-standard']!),
        $extra: state.extra as QuestionMode,
      );

  String get location => GoRouteData.$location(
        '/mockSubject/university-exams/mocks/${Uri.encodeComponent(mockId)}/content',
        queryParams: {
          'course-id': courseId,
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

extension $StandardMockResultPageRouteExtension on StandardMockResultPageRoute {
  static StandardMockResultPageRoute _fromState(GoRouterState state) =>
      StandardMockResultPageRoute(
        courseImage: state.queryParameters['course-image']!,
        courseName: state.queryParameters['course-name']!,
        isStandard: _$boolConverter(state.queryParameters['is-standard']!),
        $extra: state.extra as ResultPageParams,
      );

  String get location => GoRouteData.$location(
        '/mockSubject/university-exams/standard-mock-result',
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

extension $MyMockExamPageRouteExtension on MyMockExamPageRoute {
  static MyMockExamPageRoute _fromState(GoRouterState state) =>
      MyMockExamPageRoute(
        mockId: state.pathParameters['mockId']!,
        $extra: state.extra as QuestionMode,
      );

  String get location => GoRouteData.$location(
        '/my-exams/mocks/${Uri.encodeComponent(mockId)}',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

extension $MyMockExamChatWithAIPageRouteExtension
    on MyMockExamChatWithAIPageRoute {
  static MyMockExamChatWithAIPageRoute _fromState(GoRouterState state) =>
      MyMockExamChatWithAIPageRoute(
        mockId: state.pathParameters['mockId']!,
        questionId: state.pathParameters['questionId']!,
        isStandard: _$boolConverter(state.queryParameters['is-standard']!),
        question: state.queryParameters['question']!,
        $extra: state.extra as QuestionMode,
      );

  String get location => GoRouteData.$location(
        '/my-exams/mocks/${Uri.encodeComponent(mockId)}/chat/${Uri.encodeComponent(questionId)}',
        queryParams: {
          'is-standard': isStandard.toString(),
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

extension $MyMockExamContentPageRouteExtension on MyMockExamContentPageRoute {
  static MyMockExamContentPageRoute _fromState(GoRouterState state) =>
      MyMockExamContentPageRoute(
        mockId: state.pathParameters['mockId']!,
        courseId: state.queryParameters['course-id']!,
        $extra: state.extra as QuestionMode,
      );

  String get location => GoRouteData.$location(
        '/my-exams/mocks/${Uri.encodeComponent(mockId)}/content',
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

extension $MyMockExamResultPageRouteExtension on MyMockExamResultPageRoute {
  static MyMockExamResultPageRoute _fromState(GoRouterState state) =>
      MyMockExamResultPageRoute(
        isStandard: _$boolConverter(state.queryParameters['is-standard']!),
        $extra: state.extra as ResultPageParams,
      );

  String get location => GoRouteData.$location(
        '/my-exams/standard-mock-result',
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
        readOnly: _$boolConverter(state.pathParameters['readOnly']!),
      );

  String get location => GoRouteData.$location(
        '/course/${Uri.encodeComponent(courseId)}/content/${Uri.encodeComponent(readOnly.toString())}',
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
        readOnly: _$boolConverter(state.pathParameters['readOnly']!),
        subChapterId: state.queryParameters['sub-chapter-id']!,
      );

  String get location => GoRouteData.$location(
        '/course/${Uri.encodeComponent(courseId)}/content/${Uri.encodeComponent(readOnly.toString())}/chat',
        queryParams: {
          'sub-chapter-id': subChapterId,
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

extension $RecommendedMockPageRouteExtension on RecommendedMockPageRoute {
  static RecommendedMockPageRoute _fromState(GoRouterState state) =>
      RecommendedMockPageRoute(
        mockId: state.pathParameters['mockId']!,
        $extra: state.extra as QuestionMode,
      );

  String get location => GoRouteData.$location(
        '/mock/${Uri.encodeComponent(mockId)}',
      );

  void go(BuildContext context) => context.go(location, extra: $extra);

  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: $extra);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: $extra);

  void replace(BuildContext context) =>
      context.replace(location, extra: $extra);
}

extension $RecommendedMockChatWithAIPageRouteExtension
    on RecommendedMockChatWithAIPageRoute {
  static RecommendedMockChatWithAIPageRoute _fromState(GoRouterState state) =>
      RecommendedMockChatWithAIPageRoute(
        mockId: state.pathParameters['mockId']!,
        questionId: state.pathParameters['questionId']!,
        question: state.queryParameters['question']!,
        $extra: state.extra as QuestionMode,
      );

  String get location => GoRouteData.$location(
        '/mock/${Uri.encodeComponent(mockId)}/chat/${Uri.encodeComponent(questionId)}',
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

extension $RecommendedMockContentPageRouteExtension
    on RecommendedMockContentPageRoute {
  static RecommendedMockContentPageRoute _fromState(GoRouterState state) =>
      RecommendedMockContentPageRoute(
        mockId: state.pathParameters['mockId']!,
        courseId: state.queryParameters['course-id']!,
        $extra: state.extra as QuestionMode,
      );

  String get location => GoRouteData.$location(
        '/mock/${Uri.encodeComponent(mockId)}/content',
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
