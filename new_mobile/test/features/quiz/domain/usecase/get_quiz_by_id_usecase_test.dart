import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prep_genie/features/question/domain/entities/question.dart';
import 'package:prep_genie/features/question/domain/entities/user_answer.dart';
import 'package:prep_genie/features/quiz/quiz.dart';

import 'save_quiz_score_usecase_test.mocks.dart';

void main() {
  late GetQuizByIdUsecase usecase;
  late MockQuizRepository mockQuizRepository;

  setUp(() {
    mockQuizRepository = MockQuizRepository();
    usecase = GetQuizByIdUsecase(mockQuizRepository);
  });

  const tId = "test id";
  const question = Question(
      isLiked: false,
      id: "649448dbf296abbe4531d110",
      courseId: "64943fd3f296abbe4531d06b",
      chapterId: "649440e9f296abbe4531d06f",
      subChapterId: "649441bbf296abbe4531d077",
      description:
          "What is the benefit of using an intranet within an organization?",
      choiceA: "Improved productivity and collaboration",
      choiceB: "Access to the global network",
      choiceC: "Enhanced security for online transactions",
      choiceD: "Ability to connect with other organizations",
      answer: "choice_A",
      explanation:
          "Using an intranet within an organization can improve productivity, streamline communication, and enhance collaboration among employees.",
      isForQuiz: true);

  const userAnswer = UserAnswer(
      userId: "6539339b0d8e1130915dc74d",
      questionId: "653cb1f54535227899808924",
      userAnswer: "choice_E");

  const questionAnswers = [
    QuestionAnswer(question: question, userAnswer: userAnswer)
  ];
  const quizQuestion = QuizQuestion(
      id: tId, name: "name", userId: tId, questionAnswers: questionAnswers);

  test(
    "Should save quize score from repository",
    () async {
      when(mockQuizRepository.getQuizById(quizId: tId, isRefreshed: false))
          .thenAnswer((_) async => const Right(quizQuestion));

      final result = await usecase
          .call(const GetQuizByIdParams(quizId: tId, isRefreshed: false));

      expect(result, const Right(quizQuestion));

      verify(mockQuizRepository.getQuizById(quizId: tId, isRefreshed: false));

      verifyNoMoreInteractions(mockQuizRepository);
    },
  );
}
