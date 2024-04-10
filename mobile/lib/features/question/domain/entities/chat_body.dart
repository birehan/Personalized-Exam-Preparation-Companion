import 'package:equatable/equatable.dart';

import '../../../features.dart';

class ChatBody extends Equatable {
  final bool isContest;
  final String questionId;
  final String userQuestion;
  final List<ChatHistory> chatHistory;

  const ChatBody({
    required this.isContest,
    required this.questionId,
    required this.userQuestion,
    required this.chatHistory,
  });

  @override
  List<Object?> get props => [
        isContest,
        questionId,
        userQuestion,
        chatHistory,
      ];
}
