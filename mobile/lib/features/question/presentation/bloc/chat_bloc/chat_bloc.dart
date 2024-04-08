import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/core.dart';
import '../../../../features.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatUsecase chatUsecase;

  ChatBloc({
    required this.chatUsecase,
  }) : super(ChatInitial()) {
    on<SendChatEvent>(_onSendChat);
  }

  void _onSendChat(SendChatEvent event, Emitter<ChatState> emit) async {
    emit(const SendChatState(status: ChatStatus.loading));
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

  ChatState _failureOrChat(Either<Failure, ChatResponse> chatOrFailure) {
    return chatOrFailure.fold(
      (l) => const SendChatState(status: ChatStatus.error),
      (chatResponse) => SendChatState(
        status: ChatStatus.loaded,
        chatResponse: chatResponse,
      ),
    );
  }
}
