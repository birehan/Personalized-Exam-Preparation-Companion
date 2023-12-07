import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skill_bridge_mobile/features/authentication/presentation/pages/cube_animation_page.dart';
import 'package:skill_bridge_mobile/features/bookmarks/presentation/pages/bookmarked_content_page.dart';
import 'package:skill_bridge_mobile/features/bookmarks/presentation/pages/bookmarked_question_page.dart';
import 'package:skill_bridge_mobile/features/course/presentation/pages/content_final_page.dart';
import 'package:skill_bridge_mobile/features/course/presentation/pages/content_page.dart';
import 'package:skill_bridge_mobile/features/profile/presentation/pages/user_leaderboard_page.dart';

import '../../features/bookmarks/domain/entities/bookmarked_contents.dart';
import '../../features/bookmarks/domain/entities/bookmarked_questions.dart';
import '../../features/features.dart';
import '../../features/profile/domain/entities/user_leaderboard_entity.dart';
import '../../features/question/presentation/pages/end_of_chapter_question_page.dart';
import '../../features/question/presentation/pages/end_of_questions_result_page.dart';
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

@TypedGoRoute<OnboardingQuestionPagesRoute>(
  name: 'onboardingQuestions',
  path: '/onboarding-questions',
)
class OnboardingQuestionPagesRoute extends GoRouteData {
  OnboardingQuestionPagesRoute();

  @override
  Widget build(context, state) => const OnboardingQuestionPages();
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
    TypedGoRoute<MyCoursesPageRoute>(
      name: 'myCourses',
      path: 'my-courses',
      routes: <TypedGoRoute<GoRouteData>>[
        TypedGoRoute<SearchCoursesPageRoute>(
          path: 'searchCourses',
        ),
      ],
    ),
    TypedGoRoute<ChooseSubjectPageRoute>(
      name: 'chooseSubject',
      path: 'choose-subject',
    ),
    TypedGoRoute<ExamsPageRoute>(
      name: 'examsPage',
      path: 'exams',
    ),
    TypedGoRoute<ChooseMockSubjectPageRoute>(
      name: 'mockSubject',
      path: 'mockSubject',
      routes: <TypedGoRoute<GoRouteData>>[
        TypedGoRoute<UniversityMockExamPageRoute>(
          name: 'universityExamPage',
          path: 'university-exams',
          routes: <TypedGoRoute<GoRouteData>>[
            TypedGoRoute<StandardMockExamsPageRoute>(
              name: 'generalMocks',
              path: 'mocks/:mockId',
              routes: <TypedGoRoute<GoRouteData>>[
                TypedGoRoute<StandardMockChatWithAIPageRoute>(
                  name: 'standardMockChatPage',
                  path: 'chat/:questionId',
                ),
                TypedGoRoute<StandardMockContentPageRoute>(
                  path: 'content',
                ),
              ],
            ),
            TypedGoRoute<StandardMockResultPageRoute>(
              name: 'standardMockResult',
              path: 'standard-mock-result',
            ),
          ],
        ),
        // TypedGoRoute<AiGeneratedExamsPageRoute>(
        //   name: 'aiGeneratedExamPage',
        //   path: 'ai-generated-exams',
        // ),
      ],
    ),
    TypedGoRoute<MyExamsPageRoute>(
      name: 'myExamsPage',
      path: 'my-exams',
      routes: <TypedGoRoute<GoRouteData>>[
        TypedGoRoute<MyMockExamPageRoute>(
          name: 'myMocks',
          path: 'mocks/:mockId',
          routes: <TypedGoRoute<GoRouteData>>[
            TypedGoRoute<MyMockExamChatWithAIPageRoute>(
              name: 'myStandardMockChatPage',
              path: 'chat/:questionId',
            ),
            TypedGoRoute<MyMockExamContentPageRoute>(
              path: 'content',
            ),
          ],
        ),
        TypedGoRoute<MyMockExamResultPageRoute>(
          name: 'myStandardMockResult',
          path: 'standard-mock-result',
        ),
      ],
    ),
    TypedGoRoute<ProfilePageRoute>(
      name: 'profile',
      path: 'profile',
      routes: <TypedGoRoute<GoRouteData>>[
        TypedGoRoute<UserLeaderboardPageRoute>(
          path: 'userLeaderboard',
        ),
      ],
    ),
    TypedGoRoute<BookmarkedContentPageRoute>(
      name: 'bookmarkedContent',
      path: 'bookmarkedContent',
    ),
    TypedGoRoute<BookmarkedQuestionPageRoute>(
      name: 'bookmarkedQuestion',
      path: 'bookmarkedQuestion',
      routes: <TypedGoRoute<GoRouteData>>[
        TypedGoRoute<BookmarkedQuestionRelatedTopicPageRoute>(
          path: 'content/:courseId',
        ),
      ],
    ),
    TypedGoRoute<CourseDetailPageRoute>(
      name: 'courseDetail',
      path: 'course/:courseId',
      routes: <TypedRoute<GoRouteData>>[
        TypedGoRoute<EndOfChapterPageRoute>(
          path: 'endOfChapterPage',
          name: 'endOfChapterpage',
        ),
        TypedGoRoute<CreateQuizPageRoute>(
          name: 'createQuiz',
          path: 'quiz',
        ),
        TypedGoRoute<ContentPageRoute>(
          name: 'content',
          path: 'content/:readOnly',
          routes: <TypedGoRoute<GoRouteData>>[
            TypedGoRoute<ChatWithContentPageRoute>(
              name: 'chatWithContent',
              path: 'chat',
            ),
          ],
        ),
        TypedGoRoute<QuizQuestionPageRoute>(
          name: 'newQuizQuestionPage',
          path: 'quiz/:quizId',
          routes: <TypedGoRoute<GoRouteData>>[
            TypedGoRoute<QuizChatWithAIPageRoute>(
              path: 'chat/:questionId',
            ),
            TypedGoRoute<QuizContentPageRoute>(
              path: 'content',
            ),
          ],
        ),
        TypedGoRoute<QuizResultPageRoute>(
          name: 'quizResultPageRoute',
          path: 'quiz-result-page',
        ),
        TypedGoRoute<EndOfChapterQuestionsPageRoute>(
          name: 'endOfChapterQuestions',
          path: 'endOfChapterQuestions',
        ),
        TypedGoRoute<EndOfSubChapterQuestionsPageRoute>(
          path: 'endOfSubchapter',
          name: 'endOfSubchapter',
        ),
        TypedGoRoute<EndOfQuestionsResultPageRoute>(
          name: 'endOfQuestionsResult',
          path: 'endOfQuestionsResult',
        )
      ],
    ),
    TypedGoRoute<RecommendedMockPageRoute>(
      name: 'recommendedMock',
      path: 'mock/:mockId',
      routes: <TypedGoRoute<GoRouteData>>[
        TypedGoRoute<RecommendedMockChatWithAIPageRoute>(
          name: 'recommendedMockChatPage',
          path: 'chat/:questionId',
        ),
        TypedGoRoute<RecommendedMockContentPageRoute>(
          path: 'content',
        ),
      ],
    ),
    TypedGoRoute<RecommendedMockResultPageRoute>(
      name: 'recommendedMockResult',
      path: 'recommended-mock-result',
    ),
  ],
)
class HomePageRoute extends GoRouteData {
  HomePageRoute();

  @override
  Widget build(context, state) => const MyHomePage();
}

class MyCoursesPageRoute extends GoRouteData {
  MyCoursesPageRoute();

  @override
  Widget build(context, state) => const MyCoursesPage();
}

class ChooseSubjectPageRoute extends GoRouteData {
  ChooseSubjectPageRoute({
    this.$extra,
  });

  final bool? $extra;

  @override
  Widget build(context, state) => ChooseSubjectPage(
        forQuestionGeneration: $extra,
      );
}

class ExamsPageRoute extends GoRouteData {
  ExamsPageRoute();

  @override
  Widget build(context, state) => const ExamsPage();
}

class ChooseMockSubjectPageRoute extends GoRouteData {
  ChooseMockSubjectPageRoute({
    required this.isStandard,
  });
  final bool isStandard;

  @override
  Widget build(context, state) =>
      SelectSubjectForMockPage(isStandard: isStandard);
}

class UniversityMockExamPageRoute extends GoRouteData {
  UniversityMockExamPageRoute({
    required this.courseImage,
    required this.courseName,
    required this.isStandard,
  });

  final String courseImage;
  final String courseName;
  final bool isStandard;

  @override
  Widget build(context, state) => MockExamsPage(
        imageUrl: courseImage,
        courseName: courseName,
        isStandard: isStandard,
      );
}

class StandardMockExamsPageRoute extends GoRouteData {
  StandardMockExamsPageRoute({
    required this.mockId,
    required this.$extra,
    required this.courseImage,
    required this.courseName,
    required this.isStandard,
  });

  final String mockId;
  final QuestionMode $extra;
  final String courseImage;
  final String courseName;
  final bool isStandard;

  @override
  Widget build(context, state) => MockExamQuestionPage(
        mockType: MockType.standardMocks,
        mockId: mockId,
        questionMode: $extra,
        courseName: courseName,
        courseImage: courseImage,
        isStandard: isStandard,
      );
}

class StandardMockContentPageRoute extends GoRouteData {
  StandardMockContentPageRoute({
    required this.courseId,
    required this.mockId,
    required this.$extra,
    required this.courseImage,
    required this.courseName,
    required this.isStandard,
  });

  final String courseId;
  final String mockId;
  final QuestionMode $extra;
  final String courseImage;
  final String courseName;
  final bool isStandard;

  @override
  Widget build(context, state) => RelatedTopicContentPage(
        courseId: courseId,
      );
}

class StandardMockChatWithAIPageRoute extends GoRouteData {
  StandardMockChatWithAIPageRoute({
    required this.mockId,
    required this.questionId,
    required this.$extra,
    required this.courseImage,
    required this.courseName,
    required this.isStandard,
    required this.question,
  });

  final String mockId;
  final String questionId;
  final QuestionMode $extra;
  final String courseImage;
  final String courseName;
  final bool isStandard;
  final String question;

  @override
  Widget build(context, state) => ChatPage(
        questionId: questionId,
        isChatWithContent: false,
        question: question,
      );
}

class StandardMockResultPageRoute extends GoRouteData {
  StandardMockResultPageRoute({
    required this.$extra,
    required this.courseImage,
    required this.courseName,
    required this.isStandard,
  });

  final ResultPageParams $extra;
  final String courseImage;
  final String courseName;
  final bool isStandard;

  @override
  Widget build(context, state) => ResultPage(resultPageParams: $extra);
}

class AiGeneratedExamsPageRoute extends GoRouteData {
  AiGeneratedExamsPageRoute({
    required this.isStandard,
  });

  final bool isStandard;

  @override
  Widget build(context, state) => const AiGeneratedExamsPage();
}

class MyExamsPageRoute extends GoRouteData {
  MyExamsPageRoute();

  @override
  Widget build(context, state) => const MyExamsPage();
}

class MyMockExamPageRoute extends GoRouteData {
  MyMockExamPageRoute({
    required this.mockId,
    required this.$extra,
    // required this.isStandard,
  });

  final String mockId;
  final QuestionMode $extra;
  // final bool isStandard;

  @override
  Widget build(context, state) => MockExamQuestionPage(
        mockId: mockId,
        mockType: MockType.myStandardMocks,
        questionMode: $extra,
        // isStandard: isStandard,
      );
}

class MyMockExamContentPageRoute extends GoRouteData {
  MyMockExamContentPageRoute({
    required this.courseId,
    required this.mockId,
    required this.$extra,
    // required this.isStandard,
  });

  final String courseId;
  final String mockId;
  final QuestionMode $extra;
  // final bool isStandard;

  @override
  Widget build(context, state) => RelatedTopicContentPage(
        courseId: courseId,
      );
}

class MyMockExamChatWithAIPageRoute extends GoRouteData {
  MyMockExamChatWithAIPageRoute({
    required this.mockId,
    required this.questionId,
    required this.$extra,
    required this.isStandard,
    required this.question,
  });

  final String mockId;
  final String questionId;
  final QuestionMode $extra;
  final bool isStandard;
  final String question;

  @override
  Widget build(context, state) => ChatPage(
        questionId: questionId,
        isChatWithContent: false,
        question: question,
      );
}

class MyMockExamResultPageRoute extends GoRouteData {
  MyMockExamResultPageRoute({
    required this.$extra,
    required this.isStandard,
  });

  final ResultPageParams $extra;
  final bool isStandard;

  @override
  build(context, state) => ResultPage(resultPageParams: $extra);
}

class ProfilePageRoute extends GoRouteData {
  ProfilePageRoute();

  @override
  Widget build(context, state) => const ProfilePage();
}

class CourseDetailPageRoute extends GoRouteData {
  CourseDetailPageRoute({
    required this.courseId,
    this.lastStartedSubChapterId,
  });

  final String courseId;
  final String? lastStartedSubChapterId;

  @override
  Widget build(context, state) => CourseDetailPageNew(
        courseId: courseId,
        lastStartedSubChapterId: lastStartedSubChapterId,
      );
}

class CreateQuizPageRoute extends GoRouteData {
  CreateQuizPageRoute({required this.courseId});
  final String courseId;

  @override
  Widget build(context, state) => CreateQuizPage(courseId: courseId);
}

class ContentPageRoute extends GoRouteData {
  ContentPageRoute({required this.courseId, required this.readOnly});

  final String courseId;
  final bool readOnly;

  @override
  Widget build(context, state) =>
      ContentPage(courseId: courseId, readOnly: readOnly);
}

class ChatWithContentPageRoute extends GoRouteData {
  ChatWithContentPageRoute({
    required this.courseId,
    required this.subChapterId,
    required this.readOnly,
  });

  final String courseId;
  final String subChapterId;
  final bool readOnly;

  @override
  Widget build(context, state) => ChatPage(
        questionId: subChapterId,
        isChatWithContent: true,
      );
}

class BookmarkedContentPageRoute extends GoRouteData {
  final BookmarkedContent $extra;

  BookmarkedContentPageRoute({required this.$extra});
  @override
  Widget build(context, state) =>
      BookmarkedContentPage(bookmarkedContent: $extra);
}

class BookmarkedQuestionPageRoute extends GoRouteData {
  final BookmarkedQuestions $extra;

  BookmarkedQuestionPageRoute({required this.$extra});
  @override
  Widget build(context, state) =>
      QuestionBookmarkPage(bookmarkedQuestion: $extra);
}

class BookmarkedQuestionRelatedTopicPageRoute extends GoRouteData {
  final BookmarkedQuestions $extra;
  final String courseId;

  BookmarkedQuestionRelatedTopicPageRoute({
    required this.courseId,
    required this.$extra,
  });

  @override
  Widget build(context, state) => RelatedTopicContentPage(
        courseId: courseId,
      );
}

class QuizQuestionPageRoute extends GoRouteData {
  QuizQuestionPageRoute({
    required this.courseId,
    required this.quizId,
    required this.$extra,
  });

  final String courseId;
  final String quizId;
  final QuestionMode $extra;

  @override
  Widget build(context, state) => QuizExamQuestionPage(
        courseId: courseId,
        quizId: quizId,
        questionMode: $extra,
      );
}

class QuizContentPageRoute extends GoRouteData {
  QuizContentPageRoute({
    required this.courseId,
    required this.quizId,
    required this.$extra,
  });

  final String courseId;
  final String quizId;
  final QuestionMode $extra;

  @override
  Widget build(context, state) => RelatedTopicContentPage(
        courseId: courseId,
      );
}

class QuizChatWithAIPageRoute extends GoRouteData {
  QuizChatWithAIPageRoute({
    required this.courseId,
    required this.quizId,
    required this.questionId,
    required this.$extra,
    required this.question,
  });

  final String courseId;
  final String quizId;
  final String questionId;
  final String question;
  final QuestionMode $extra;

  @override
  Widget build(context, state) => ChatPage(
        questionId: questionId,
        isChatWithContent: false,
        question: question,
      );
}

class QuizResultPageRoute extends GoRouteData {
  QuizResultPageRoute({
    required this.courseId,
    required this.$extra,
  });

  final String courseId;
  final ResultPageParams $extra;

  @override
  Widget build(context, state) => ResultPage(resultPageParams: $extra);
}

class EndOfChapterQuestionsPageRoute extends GoRouteData {
  EndOfChapterQuestionsPageRoute({
    required this.courseId,
  });

  final String courseId;

  @override
  Widget build(context, state) => EndOfChapterQuestionsPage(
        chapterId: courseId,
        courseId: courseId,
      );
}

class EndOfSubChapterQuestionsPageRoute extends GoRouteData {
  EndOfSubChapterQuestionsPageRoute({
    required this.subTopicId,
    required this.courseId,
  });

  final String subTopicId;
  final String courseId;

  @override
  Widget build(context, state) => EndOfSubtopicQuestionsPage(
        subTopicId: subTopicId,
        courseId: courseId,
      );
}

class RecommendedMockPageRoute extends GoRouteData {
  RecommendedMockPageRoute({
    required this.mockId,
    required this.$extra,
  });

  final String mockId;
  final QuestionMode $extra;

  @override
  Widget build(context, state) => MockExamQuestionPage(
        mockType: MockType.recommendedMocks,
        mockId: mockId,
        questionMode: $extra,
      );
}

class RecommendedMockContentPageRoute extends GoRouteData {
  RecommendedMockContentPageRoute({
    required this.courseId,
    required this.mockId,
    required this.$extra,
  });

  final String courseId;
  final String mockId;
  final QuestionMode $extra;

  @override
  Widget build(context, state) => RelatedTopicContentPage(
        courseId: courseId,
      );
}

class RecommendedMockChatWithAIPageRoute extends GoRouteData {
  RecommendedMockChatWithAIPageRoute({
    required this.mockId,
    required this.questionId,
    required this.$extra,
    required this.question,
  });

  final String mockId;
  final String questionId;
  final QuestionMode $extra;
  final String question;

  @override
  Widget build(context, state) => ChatPage(
        questionId: questionId,
        isChatWithContent: false,
        question: question,
      );
}

class RecommendedMockResultPageRoute extends GoRouteData {
  RecommendedMockResultPageRoute({required this.$extra});

  final ResultPageParams $extra;

  @override
  Widget build(context, state) => ResultPage(resultPageParams: $extra);
}

class EndOfQuestionsResultPageRoute extends GoRouteData {
  EndOfQuestionsResultPageRoute({required this.$extra, required this.courseId});

  final ResultPageParams $extra;
  final String courseId;

  @override
  Widget build(context, state) =>
      EndofQuestionsResultPage(resultPageParams: $extra);
}

class EndOfChapterPageRoute extends GoRouteData {
  EndOfChapterPageRoute({
    required this.courseId,
  });

  final String courseId;

  @override
  Widget build(context, state) => ContentFinalPage(
        courseId: courseId,
      );
}

class SearchCoursesPageRoute extends GoRouteData {
  @override
  Widget build(context, state) => const SearchCoursePage();
}

class UserLeaderboardPageRoute extends GoRouteData {
  final UserLeaderboardEntity $extra;

  UserLeaderboardPageRoute(this.$extra);
  @override
  Widget build(context, state) => UserLeaderboardPage(userInformations: $extra);
}
