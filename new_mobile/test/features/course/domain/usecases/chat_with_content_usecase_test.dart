import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prep_genie/features/features.dart';

import 'get_user_courses_uscase_test.mocks.dart';

void main() {
  late ChatWithContentUsecase usecase;
  late MockCourseRepositories mockCourseRepository;

  setUp(() {
    mockCourseRepository = MockCourseRepositories();
    usecase = ChatWithContentUsecase(repository: mockCourseRepository);
  });

  const chatHistory = [ChatHistory(human: "Human chat", ai: "AI chat")];

  final chatBody = ChatBody(
      isContest: true,
      questionId: "questionId",
      userQuestion: "userQuestion",
      chatHistory: chatHistory);

  const chatResponse = ChatResponse(messageResponse: "message response");

  test(
    "Should get chat response from repository",
    () async {
      when(mockCourseRepository.chat(chatBody.isContest, chatBody.questionId,
              chatBody.userQuestion, chatHistory))
          .thenAnswer((_) async => Right(chatResponse));

      final result = await usecase.call(chatBody);

      expect(result, Right(chatResponse));

      verify(mockCourseRepository.chat(chatBody.isContest, chatBody.questionId,
          chatBody.userQuestion, chatHistory));

      verifyNoMoreInteractions(mockCourseRepository);
    },
  );
}
