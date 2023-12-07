part of 'chat_with_content_bloc.dart';

class ChatWithContentEvent extends Equatable {
  const ChatWithContentEvent();

  @override
  List<Object> get props => [];
}

class SendChatWithContentEvent extends ChatWithContentEvent {
  final ChatBody chatBody;

  const SendChatWithContentEvent({
    required this.chatBody,
  });

  @override
  List<Object> get props => [chatBody];
}
