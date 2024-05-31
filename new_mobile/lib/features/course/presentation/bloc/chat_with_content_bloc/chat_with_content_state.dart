part of 'chat_with_content_bloc.dart';

class ChatWithContentState extends Equatable {
  const ChatWithContentState();

  @override
  List<Object> get props => [];
}

class ChatWithContentInitial extends ChatWithContentState {}

class SendChatWithContentState extends ChatWithContentState {
  final ChatResponse? chatResponse;
  final ChatStatus status;
  final Failure? failure;
  const SendChatWithContentState({
    required this.status,
    this.chatResponse,
    this.failure,
  });

  @override
  List<Object> get props => [status];
}
