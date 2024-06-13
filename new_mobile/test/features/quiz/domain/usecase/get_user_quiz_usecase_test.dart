import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prep_genie/features/question/domain/entities/question.dart';
import 'package:prep_genie/features/quiz/quiz.dart';

import 'save_quiz_score_usecase_test.mocks.dart';

void main() {
  late GetUserQuizUsecase usecase;
  late MockQuizRepository mockQuizRepository;

  setUp(() {
    mockQuizRepository = MockQuizRepository();
    usecase = GetUserQuizUsecase(mockQuizRepository);
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
  const quiz = Quiz(
      id: "id",
      courseId: "courseId",
      chapterIds: ["chapterIds"],
      userId: "userId",
      name: "name",
      questionIds: ["questionIds"],
      questions: questions,
      score: 5,
      isComplete: true);

  test(
    "Should create quize from repository",
    () async {
      when(mockQuizRepository.getQuizByCourseId(
              courseId: "id", isRefreshed: false))
          .thenAnswer((_) async => const Right([quiz]));

      final result = await usecase
          .call(const GetUserQuizParams(courseId: "id", isRefreshed: false));

      expect(result, const Right([quiz]));

      verify(mockQuizRepository.getQuizByCourseId(
          courseId: "id", isRefreshed: false));

      verifyNoMoreInteractions(mockQuizRepository);
    },
  );
}
