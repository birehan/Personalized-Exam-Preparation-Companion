import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:prep_genie/features/features.dart';
import '../../../../fixtures/fixture_reader.dart';

void main() {
  const totalStreak =
      TotalStreakModel(currentStreak: 1, points: 2, maxStreak: 3);
  const dailyStreak =
      DailyStreakModel(userDailyStreaks: [], totalStreak: totalStreak);

  test('should be a subclass of daily quiz entity', () async {
    // assert
    expect(dailyStreak, isA<DailyStreak>());
  });

  group('fromJson', () {
    test('should return a valid model when the JSON is recieved', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('home/daily_streak.json'));
      Map<String, dynamic> newJson = {
        'totalStreak': jsonMap,
        "userDailyStreaks": []
      };
      // act
      final result = DailyStreakModel.fromJson(newJson);
      // assert
      expect(result, dailyStreak);
    });
  });
}
