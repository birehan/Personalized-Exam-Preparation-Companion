
import 'package:flutter_test/flutter_test.dart';
import 'package:skill_bridge_mobile/features/home/data/models/user_daily_streak_model.dart';

void main() {
  group('UserDailyStreakModel', () {
    test('fromJson() should parse JSON correctly', () {
      // Example JSON data
      Map<String, dynamic> json = {
        'date': '2024-03-13',
        'activeOnDay': true,
      };

      // Parse JSON into model
      final userDailyStreakModel = UserDailyStreakModel.fromJson(json);

      // Assertions
      expect(userDailyStreakModel.date, DateTime(2024, 3, 13));
      expect(userDailyStreakModel.activeOnDay, true);
    });

    test('fromJson() should use current date if parsing fails', () {
      // Example JSON data with invalid date
      Map<String, dynamic> json = {
        'date': 'invalid_date_format',
        'activeOnDay': true,
      };

      // Parse JSON into model
      final userDailyStreakModel = UserDailyStreakModel.fromJson(json);

      // Assertions
      expect(userDailyStreakModel.date, isNotNull);
      expect(userDailyStreakModel.activeOnDay, true);
    });
  });
}
