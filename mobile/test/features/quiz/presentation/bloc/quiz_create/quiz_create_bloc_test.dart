import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prepgenie/core/error/failure.dart';
import 'package:prepgenie/features/features.dart';

import 'quiz_create_bloc_test.mocks.dart';


@GenerateNiceMocks([
  MockSpec<CreateQuizUsecase>() 
])

void main() {
  late QuizCreateBloc bloc;
  late MockCreateQuizUsecase mockCreateQuizUsecase;

  setUp(() {
    mockCreateQuizUsecase = MockCreateQuizUsecase();
    bloc = QuizCreateBloc(createQuizUsecase: mockCreateQuizUsecase);
  });

  const quizId = "quiz id";

  group('_onCreateQuiz', () {
    test('should get data from the fetch chat  usecase', () async {
      // arrange
      when(mockCreateQuizUsecase(any))
          .thenAnswer((_) async => const Right(quizId));
      // act
      bloc.add(const CreateQuizEvent(chapters: ["chapter id"],courseId: "course id",name: "name",numberOfQuestions: 20));

      await untilCalled(mockCreateQuizUsecase(any));
      // assert
      verify(mockCreateQuizUsecase(any));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () {
      // arrange
      when(mockCreateQuizUsecase(any))
          .thenAnswer((_) async => const Right(quizId));
      // assert later
      final expected = [
        const CreateQuizState(status: QuizCreateStatus.loading),
        const CreateQuizState(status: QuizCreateStatus.loaded, quizId: quizId)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const CreateQuizEvent(chapters: [],courseId: "",name: "",numberOfQuestions: 20));
    });
    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(mockCreateQuizUsecase(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        const CreateQuizState(status: QuizCreateStatus.loading),
        const CreateQuizState(
            status: QuizCreateStatus.error, errorMessage: "Server failure")
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const CreateQuizEvent(chapters: [],courseId: "",name: "",numberOfQuestions: 20));
    });
    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      when(mockCreateQuizUsecase(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        const CreateQuizState(status: QuizCreateStatus.loading),
        const CreateQuizState(
            status: QuizCreateStatus.error, errorMessage: "Cache failure")
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const CreateQuizEvent(chapters: [],courseId: "",name: "",numberOfQuestions: 20));
    });
  });
}
