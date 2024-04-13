import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prepgenie/core/error/failure.dart';
import 'package:prepgenie/features/features.dart';

import 'quiz_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<GetUserQuizUsecase>()])
void main() {
  late QuizBloc bloc;
  late MockGetUserQuizUsecase mockGetUserQuizUsecase;

  setUp(() {
    mockGetUserQuizUsecase = MockGetUserQuizUsecase();
    bloc = QuizBloc(getUserQuizUsecase: mockGetUserQuizUsecase);
  });

  const questions = [
    Question(
        isLiked: false,
        id: "653cb1f54535227899808924",
        courseId: "635981f6e40f61599e000064",
        chapterId: "635981f6e40f61599e000064",
        subChapterId: "635981f6e40f61599e000064",
        description:
            "A company uses an arithmetic sequence to determine the salaries of its employees.",
        choiceA: "900,000",
        choiceB: "750,000",
        choiceC: "1,000,000",
        choiceD: "830,000",
        answer: "choice_C",
        explanation: "The sum of an arithmetic series is given by the formula",
        isForQuiz: false)
  ];
  const quiz = [
    Quiz(
        id: "id",
        courseId: "courseId",
        chapterIds: ["chapterIds"],
        userId: "userId",
        name: "name",
        questionIds: ["questionIds"],
        questions: questions,
        score: 5,
        isComplete: true)
  ];

  group('_onGetUserQuiz', () {
    test('should get data from the fetch chat  usecase', () async {
      // arrange
      when(mockGetUserQuizUsecase(any))
          .thenAnswer((_) async => const Right(quiz));
      // act
      bloc.add(const GetUserQuizEvent(courseId: "id", isRefreshed: false));

      await untilCalled(mockGetUserQuizUsecase(any));
      // assert
      verify(mockGetUserQuizUsecase(any));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () {
      // arrange
      when(mockGetUserQuizUsecase(any))
          .thenAnswer((_) async => const Right(quiz));
      // assert later
      final expected = [
        const GetUserQuizState(status: QuizStatus.loading),
        const GetUserQuizState(status: QuizStatus.loaded, quizzes: quiz)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const GetUserQuizEvent(courseId: "id", isRefreshed: false));
    });
    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(mockGetUserQuizUsecase(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        const GetUserQuizState(status: QuizStatus.loading),
        const GetUserQuizState(
            status: QuizStatus.error, errorMessage: "Server failure")
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const GetUserQuizEvent(courseId: "id", isRefreshed: false));
    });
    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      when(mockGetUserQuizUsecase(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        const GetUserQuizState(status: QuizStatus.loading),
        const GetUserQuizState(
            status: QuizStatus.error, errorMessage: "Cache failure")
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const GetUserQuizEvent(courseId: "id", isRefreshed: false));
    });
  });
}
