import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/core.dart';
import '../../../../features.dart';

part 'chat_with_content_event.dart';
part 'chat_with_content_state.dart';

class ChatWithContentBloc
    extends Bloc<ChatWithContentEvent, ChatWithContentState> {
  final ChatWithContentUsecase chatUsecase;

  ChatWithContentBloc({
    required this.chatUsecase,
  }) : super(ChatWithContentInitial()) {
    on<SendChatWithContentEvent>(_onSendChat);
  }

  void _onSendChat(SendChatWithContentEvent event,
      Emitter<ChatWithContentState> emit) async {
    emit(const SendChatWithContentState(status: ChatStatus.loading));
    final chatOrFailure = await chatUsecase(
      ChatBody(
        isContest: event.chatBody.isContest,
        questionId: event.chatBody.questionId,
        userQuestion: event.chatBody.userQuestion,
        chatHistory: event.chatBody.chatHistory,
      ),
    );
    emit(_failureOrChat(chatOrFailure));
  }

  ChatWithContentState _failureOrChat(
      Either<Failure, ChatResponse> chatOrFailure) {
    return chatOrFailure.fold(
      (failure) => SendChatWithContentState(status: ChatStatus.error, failure: failure),
      (chatResponse) => SendChatWithContentState(
        status: ChatStatus.loaded,
        chatResponse: chatResponse,
      ),
    );
  }
}
