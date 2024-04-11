import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:skill_bridge_mobile/core/error/failure.dart';
import 'package:skill_bridge_mobile/features/features.dart';

import 'quiz_question_bloc_test.mocks.dart';

@GenerateNiceMocks(
    [MockSpec<GetQuizByIdUsecase>(), MockSpec<SaveQuizScoreUsecase>()])
void main() {
  late QuizQuestionBloc bloc;
  late MockGetQuizByIdUsecase mockGetQuizByIdUsecase;
  late MockSaveQuizScoreUsecase mockSaveQuizScoreUsecase;

  setUp(() {
    mockGetQuizByIdUsecase = MockGetQuizByIdUsecase();
    mockSaveQuizScoreUsecase = MockSaveQuizScoreUsecase();
    bloc = QuizQuestionBloc(
        getQuizByIdUsecase: mockGetQuizByIdUsecase,
        saveQuizScoreUsecase: mockSaveQuizScoreUsecase);
  });

  const question = QuestionModel(
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
      isForQuiz: false);
  const userAnswer = UserAnswerModel(
      userId: "6539339b0d8e1130915dc74d",
      questionId: "653cb1f54535227899808924",
      userAnswer: "choice_E");

  const questionAnswer = [
    QuestionAnswerModel(question: question, userAnswer: userAnswer)
  ];
  const quizQuestion = QuizQuestionModel(
      id: "653925552e238473eb80d8a9",
      name: "first quiz",
      userId: "6538d8fb48753d97e4ea235a",
      questionAnswers: questionAnswer);

  group('_onGetQuizById', () {
    test('should get data from the get quiz by id usecase', () async {
      // arrange
      when(mockGetQuizByIdUsecase(any))
          .thenAnswer((_) async => const Right(quizQuestion));
      // act
      bloc.add(const GetQuizByIdEvent(isRefreshed: false, quizId: "id"));

      await untilCalled(mockGetQuizByIdUsecase(any));
      // assert
      verify(mockGetQuizByIdUsecase(any));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () {
      // arrange
      when(mockGetQuizByIdUsecase(any))
          .thenAnswer((_) async => const Right(quizQuestion));
      // assert later
      final expected = [
        const GetQuizByIdState(status: QuizQuestionStatus.loading),
        const GetQuizByIdState(
            status: QuizQuestionStatus.loaded, quizQuestion: quizQuestion)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const GetQuizByIdEvent(isRefreshed: false, quizId: "id"));
    });
    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(mockGetQuizByIdUsecase(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        const GetQuizByIdState(status: QuizQuestionStatus.loading),
        const GetQuizByIdState(status: QuizQuestionStatus.error)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const GetQuizByIdEvent(isRefreshed: false, quizId: "id"));
    });
    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      when(mockGetQuizByIdUsecase(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        const GetQuizByIdState(status: QuizQuestionStatus.loading),
        const GetQuizByIdState(status: QuizQuestionStatus.error)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const GetQuizByIdEvent(isRefreshed: false, quizId: "id"));
    });
  });

  group('_onGetQuizAnalysis', () {
    test('should get data from the get quiz by id usecase', () async {
      // arrange
      when(mockGetQuizByIdUsecase(any))
          .thenAnswer((_) async => const Right(quizQuestion));
      // act
      bloc.add(const GetQuizAnalysisEvent(quizId: "id"));

      await untilCalled(mockGetQuizByIdUsecase(any));
      // assert
      verify(mockGetQuizByIdUsecase(any));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () {
      // arrange
      when(mockGetQuizByIdUsecase(any))
          .thenAnswer((_) async => const Right(quizQuestion));
      // assert later
      final expected = [
        const GetQuizAnalysisState(status: QuizQuestionStatus.loading),
        const GetQuizAnalysisState(
            status: QuizQuestionStatus.loaded, quizQuestion: quizQuestion)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const GetQuizAnalysisEvent(quizId: "id"));
    });
    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(mockGetQuizByIdUsecase(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        const GetQuizAnalysisState(status: QuizQuestionStatus.loading),
        const GetQuizAnalysisState(status: QuizQuestionStatus.error)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const GetQuizAnalysisEvent(quizId: "id"));
    });
    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      when(mockGetQuizByIdUsecase(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        const GetQuizAnalysisState(status: QuizQuestionStatus.loading),
        const GetQuizAnalysisState(status: QuizQuestionStatus.error)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const GetQuizAnalysisEvent(quizId: "id"));
    });
  });

  group('_onSaveQuizScore', () {
    test('should get data from the get quiz by id usecase', () async {
      // arrange
      when(mockSaveQuizScoreUsecase(any))
          .thenAnswer((_) async => const Right(unit));
      // act
      bloc.add(const SaveQuizScoreEvent(quizId: "id", score: 5));

      await untilCalled(mockSaveQuizScoreUsecase(any));
      // assert
      verify(mockSaveQuizScoreUsecase(any));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () {
      // arrange
      when(mockSaveQuizScoreUsecase(any))
          .thenAnswer((_) async => const Right(unit));
      // assert later
      final expected = [
        const SaveQuizScoreState(status: QuizQuestionStatus.loading),
        const SaveQuizScoreState(
            status: QuizQuestionStatus.loaded)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const SaveQuizScoreEvent(quizId: "id", score: 5));
    });
    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(mockSaveQuizScoreUsecase(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        const SaveQuizScoreState(status: QuizQuestionStatus.loading),
        const SaveQuizScoreState(status: QuizQuestionStatus.error)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const SaveQuizScoreEvent(quizId: "id", score: 5));
    });
    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      when(mockSaveQuizScoreUsecase(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        const SaveQuizScoreState(status: QuizQuestionStatus.loading),
        const SaveQuizScoreState(status: QuizQuestionStatus.error)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const SaveQuizScoreEvent(quizId: "id", score: 5));
    });
  });
}
