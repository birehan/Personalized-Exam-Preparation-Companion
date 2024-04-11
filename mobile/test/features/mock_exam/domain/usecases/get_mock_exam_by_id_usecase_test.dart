import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:skill_bridge_mobile/features/features.dart';
import 'package:skill_bridge_mobile/features/mock_exam/domain/entities/mock.dart' as mocks;

import 'add_mock_to_user_mocks_usecase_test.mocks.dart';

void main(){
  late GetMockExamByIdUsecase usecase;
  late MockMockExamRepository mockExamRepository;

   setUp(() {
    mockExamRepository = MockMockExamRepository();
    usecase = GetMockExamByIdUsecase(mockExamRepository);
  });

  const tId = "test id";
  const question = Question(isLiked: false, id: tId, courseId: tId, chapterId: tId, subChapterId: tId, description: "description", choiceA: "choiceA", choiceB: "choiceB", choiceC: "choiceC", choiceD: "choiceD", answer: "answer", explanation: "explanation", isForQuiz: true);
  const userAnswer = UserAnswer(userId: tId, questionId: tId, userAnswer: "userAnswer");
  const mockQuestion = MockQuestion(question: question, userAnswer: userAnswer);
  const mock = mocks.Mock(id: tId, name: "name", userId: tId, mockQuestions: [mockQuestion]);

  
  
   test(
    "Should add mock to user mocks response from repository",
    () async {
      when(mockExamRepository.getMockById(tId, 1))
          .thenAnswer((_) async => const Right(mock));

      final result = await usecase.call(const MockExamParams(id: tId, pageNumber: 1));

      expect(result, const Right(mock));

      verify(mockExamRepository.getMockById(tId, 1));

      verifyNoMoreInteractions(mockExamRepository);
    },
  );

}