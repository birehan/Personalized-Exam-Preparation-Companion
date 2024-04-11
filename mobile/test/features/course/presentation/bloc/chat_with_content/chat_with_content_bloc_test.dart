import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prepgenie/core/error/failure.dart';
import 'package:prepgenie/features/features.dart';

import 'chat_with_content_bloc_test.mocks.dart';




@GenerateNiceMocks([
  MockSpec<ChatWithContentUsecase>() 
])

void main() {
  late ChatWithContentBloc bloc;
  late MockChatWithContentUsecase mockChatWithContentUsecase;
  

  setUp(() {
    mockChatWithContentUsecase = MockChatWithContentUsecase();
    bloc = ChatWithContentBloc(chatUsecase: mockChatWithContentUsecase);
  });


  const chatHistory = [ChatHistory(human: "Human chat", ai: "AI chat")];

  const chatBody =  ChatBody(isContest: true, questionId: "questionId", userQuestion: "userQuestion", chatHistory: chatHistory);

  const chatResponse =  ChatResponse(messageResponse: "message response");

  group('_onChat', () {
    test('should get data from the fetch chat  usecase', () async {
      // arrange
      when(mockChatWithContentUsecase(any))
          .thenAnswer((_) async => const Right(chatResponse));
      // act
      bloc.add(const SendChatWithContentEvent(chatBody: chatBody));

      await untilCalled(mockChatWithContentUsecase(any));
      // assert
      verify(mockChatWithContentUsecase(any));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () {
      // arrange
      when(mockChatWithContentUsecase(any))
          .thenAnswer((_) async =>  const Right(chatResponse));
      // assert later
      final expected = [
        const SendChatWithContentState(status: ChatStatus.loading),
         const SendChatWithContentState(status: ChatStatus.loaded, chatResponse: chatResponse)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const SendChatWithContentEvent(chatBody: chatBody));
    });
    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(mockChatWithContentUsecase(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [const SendChatWithContentState(status: ChatStatus.loading), const SendChatWithContentState(status: ChatStatus.error)];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const SendChatWithContentEvent(chatBody: chatBody));
    });
    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      when(mockChatWithContentUsecase(any)).thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [const SendChatWithContentState(status: ChatStatus.loading), const SendChatWithContentState(status: ChatStatus.error)];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const SendChatWithContentEvent(chatBody: chatBody));
    });
  });
}