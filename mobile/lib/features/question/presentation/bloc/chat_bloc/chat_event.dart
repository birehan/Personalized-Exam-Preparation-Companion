part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class SendChatEvent extends ChatEvent {
  final ChatBody chatBody;

  const SendChatEvent({
    required this.chatBody,
  });

  @override
  List<Object> get props => [chatBody];
}
