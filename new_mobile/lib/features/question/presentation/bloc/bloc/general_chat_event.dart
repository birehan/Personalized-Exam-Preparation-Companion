part of 'general_chat_bloc.dart';

class GeneralChatEvent extends Equatable {
  const GeneralChatEvent();

  @override
  List<Object> get props => [];
}

class GeneralChatSendEvent extends GeneralChatEvent {
  final String message;
  final List<ChatHistory> chatHistory;
  final bool isFirstChat;
  final String pageName;
  const GeneralChatSendEvent(
      {required this.message,
      required this.isFirstChat,
      required this.chatHistory,
      required this.pageName});
}
