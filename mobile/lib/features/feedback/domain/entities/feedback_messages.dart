import 'package:equatable/equatable.dart';

class FeedbackMessages extends Equatable {
  final String type;
  final List<String> messages;

  const FeedbackMessages({required this.type, required this.messages});
  @override
  List<Object?> get props => [];
}
