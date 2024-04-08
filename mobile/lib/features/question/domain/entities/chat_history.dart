// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class ChatHistory extends Equatable {
  final String human;
  final String ai;

  const ChatHistory({
    required this.human,
    required this.ai,
  });

  ChatHistory copyWith({
    String? human,
    String? ai,
  }) {
    return ChatHistory(
      human: human ?? this.human,
      ai: ai ?? this.ai,
    );
  }

  @override
  List<Object?> get props => [human, ai];
}
