import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prep_genie/core/error/failure.dart';
import 'package:prep_genie/features/mock_exam/mock_exam.dart';
import 'package:prep_genie/features/mock_exam/domain/entities/mock.dart'
    as mocks;
import 'package:prep_genie/features/question/domain/entities/question.dart';
import 'package:prep_genie/features/question/domain/entities/user_answer.dart';

import 'mock_question_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<GetMockExamByIdUsecase>(),
])
void main() {
  late MockQuestionBloc bloc;
  late MockGetMockExamByIdUsecase mockExamByIdUsecase;

  setUp(() {
    mockExamByIdUsecase = MockGetMockExamByIdUsecase();
    bloc = MockQuestionBloc(getMockExamByIdUsecase: mockExamByIdUsecase);
  });

  const tId = "test id";
  const question = Question(
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

  var userAnswer = const UserAnswer(
      userId: "6539339b0d8e1130915dc74d",
      questionId: "653cb1f54535227899808924",
      userAnswer: "choice_E");
  var mockQuestions = [
    MockQuestion(question: question, userAnswer: userAnswer)
  ];
  var mockModel = mocks.Mock(
      id: "65409f8955ae50031e35169f",
      name: "SAT Entrance Exam 1",
      userId: "6539339b0d8e1130915dc74d",
      mockQuestions: mockQuestions);

  group('_onGetMockById', () {
    test('should get data from the get department mocks usecase', () async {
      // arrange
      when(mockExamByIdUsecase(any)).thenAnswer((_) async => Right(mockModel));
      // act
      bloc.add(const GetMockByIdEvent(id: tId, numberOfQuestions: 20));

      await untilCalled(mockExamByIdUsecase(any));
      // assert
      verify(mockExamByIdUsecase(any));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () {
      // arrange
      when(mockExamByIdUsecase(any)).thenAnswer((_) async => Right(mockModel));
      // assert later
      final expected = [
        const GetMockExamByIdState(status: MockQuestionStatus.loading),
        GetMockExamByIdState(status: MockQuestionStatus.loaded, mock: mockModel)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const GetMockByIdEvent(id: tId, numberOfQuestions: 20));
    });
    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(mockExamByIdUsecase(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        const GetMockExamByIdState(status: MockQuestionStatus.loading),
        const GetMockExamByIdState(status: MockQuestionStatus.error)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const GetMockByIdEvent(id: tId, numberOfQuestions: 20));
    });
    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      when(mockExamByIdUsecase(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        const GetMockExamByIdState(status: MockQuestionStatus.loading),
        const GetMockExamByIdState(status: MockQuestionStatus.error)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const GetMockByIdEvent(id: tId, numberOfQuestions: 20));
    });
  });

  group('_onLoadMockPageEvent', () {
    test('should get data from the get department mocks usecase', () async {
      // arrange
      when(mockExamByIdUsecase(any)).thenAnswer((_) async => Right(mockModel));
      // act
      bloc.add(const GetMockByIdEvent(id: tId, numberOfQuestions: 20));
      bloc.add(const LoadMockPageEvent(id: tId, pageNumber: 1));

      await untilCalled(mockExamByIdUsecase(any));
      // assert
      verify(mockExamByIdUsecase(any));
    });

    // test('should emit [Loading, Loaded] when data is gotten successfully', () {
    //   // arrange
    //   when(mockExamByIdUsecase(any))
    //       .thenAnswer((_) async =>  Right(mockModel));
    //   // assert later
    //   final expected = [
    //     const GetMockExamByIdState(status: MockQuestionStatus.loading),
    //      GetMockExamByIdState(status: MockQuestionStatus.loaded, mock: mockModel)
    //   ];

    //   expectLater(bloc.stream, emitsInOrder(expected));
    //   // act
    //   bloc.add(const LoadMockPageEvent(id: tId, pageNumber: 1));
    // });
    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(mockExamByIdUsecase(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        const GetMockExamByIdState(status: MockQuestionStatus.loading),
        const GetMockExamByIdState(status: MockQuestionStatus.error)
      ];
      bloc.add(const GetMockByIdEvent(id: tId, numberOfQuestions: 20));
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const LoadMockPageEvent(id: tId, pageNumber: 1));
    });
    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      when(mockExamByIdUsecase(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        const GetMockExamByIdState(status: MockQuestionStatus.loading),
        const GetMockExamByIdState(status: MockQuestionStatus.error)
      ];
      bloc.add(const GetMockByIdEvent(id: tId, numberOfQuestions: 20));
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const LoadMockPageEvent(id: tId, pageNumber: 1));
    });
  });

  group('_onGetMockAnalysis', () {
    test('should get data from the get department mocks usecase', () async {
      // arrange
      when(mockExamByIdUsecase(any)).thenAnswer((_) async => Right(mockModel));
      // act

      bloc.add(const GetMockAnalysisEvent(id: tId));

      await untilCalled(mockExamByIdUsecase(any));
      // assert
      verify(mockExamByIdUsecase(any));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () {
      // arrange
      when(mockExamByIdUsecase(any)).thenAnswer((_) async => Right(mockModel));
      // assert later
      final expected = [
        const GetMockAnalysisState(status: MockQuestionStatus.loading),
        GetMockAnalysisState(status: MockQuestionStatus.loaded, mock: mockModel)
      ];

      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const GetMockAnalysisEvent(id: tId));
    });
    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(mockExamByIdUsecase(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        const GetMockAnalysisState(status: MockQuestionStatus.loading),
        const GetMockAnalysisState(status: MockQuestionStatus.error)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const GetMockAnalysisEvent(id: tId));
    });
    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      when(mockExamByIdUsecase(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        const GetMockAnalysisState(status: MockQuestionStatus.loading),
        const GetMockAnalysisState(status: MockQuestionStatus.error)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const GetMockAnalysisEvent(id: tId));
    });
  });
}
