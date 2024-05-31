import '../../../features.dart';

class DailyQuestModel extends DailyQuest {
  const DailyQuestModel({
    required super.challenge,
    required super.expected,
    required super.completed,
  });

  factory DailyQuestModel.fromJson(Map<String, dynamic> json) {
    return DailyQuestModel(
      challenge: json['challenge'] ?? '',
      expected: json['expected'] ?? 0,
      completed: json['completed'] ?? 0,
    );
  }
}
