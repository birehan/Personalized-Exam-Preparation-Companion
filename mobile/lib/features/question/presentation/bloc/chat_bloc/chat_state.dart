part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

enum ChatStatus { loading, loaded, error }

class SendChatState extends ChatState {
  final ChatResponse? chatResponse;
  final ChatStatus status;

  const SendChatState({
    required this.status,
    this.chatResponse,
  });

  @override
  List<Object> get props => [status];
}
