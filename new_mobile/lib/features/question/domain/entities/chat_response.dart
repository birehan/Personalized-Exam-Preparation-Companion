import 'package:equatable/equatable.dart';

class ChatResponse extends Equatable {
  final String messageResponse;

  const ChatResponse({required this.messageResponse});

  @override
  List<Object?> get props => [messageResponse];
}
