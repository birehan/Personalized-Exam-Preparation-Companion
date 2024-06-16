import 'package:equatable/equatable.dart';
import 'package:prep_genie/features/question/domain/entities/chat_history.dart';

class GeneralChatEntity extends Equatable {
  final String? userQuestion;
  final String? pageName;
  final List<ChatHistory> chatHistory;

  const GeneralChatEntity(
      {required this.chatHistory, this.userQuestion, this.pageName});

  @override
  List<Object?> get props => [
        chatHistory,
        userQuestion,
      ];
}
