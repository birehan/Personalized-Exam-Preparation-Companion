import 'package:flutter_test/flutter_test.dart';
import 'package:skill_bridge_mobile/features/home/data/models/daily_quest_model.dart';

void main() {
  group('DailyQuestModel', () {
    test('fromJson should create a valid DailyQuestModel instance', () {
      final Map<String, dynamic> jsonData = {
        'challenge': 'Sample Challenge',
        'expected': 10,
        'completed': 5,
      };

      final DailyQuestModel dailyQuest = DailyQuestModel.fromJson(jsonData);

      expect(dailyQuest.challenge, 'Sample Challenge');
      expect(dailyQuest.expected, 10);
      expect(dailyQuest.completed, 5);
    });

    test('fromJson should handle null values', () {
      final Map<String, dynamic> jsonData = {
        // Missing 'challenge' field intentionally to test default value
        'expected': null,
        'completed': null,
      };

      final DailyQuestModel dailyQuest = DailyQuestModel.fromJson(jsonData);

      expect(dailyQuest.challenge, '');
      expect(dailyQuest.expected, 0);
      expect(dailyQuest.completed, 0);
    });

    test('fromJson should handle missing values', () {
      final Map<String, dynamic> jsonData = {};

      final DailyQuestModel dailyQuest = DailyQuestModel.fromJson(jsonData);

      expect(dailyQuest.challenge, '');
      expect(dailyQuest.expected, 0);
      expect(dailyQuest.completed, 0);
    });
  });
}
