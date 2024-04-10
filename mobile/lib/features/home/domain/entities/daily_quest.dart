import 'package:equatable/equatable.dart';

class DailyQuest extends Equatable {
  const DailyQuest({
    required this.challenge,
    required this.expected,
    required this.completed,
  });

  final String challenge;
  final int expected;
  final int completed;

  @override
  List<Object> get props => [challenge, expected, completed];
}
