import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:prepgenie/features/features.dart';
import '../../../../fixtures/fixture_reader.dart';

void main() {
  const totalStreak = TotalStreakModel( currentStreak: 1, points: 2, maxStreak: 3);

  test('should be a subclass of daily quiz entity', () async {
    // assert
    expect(totalStreak, isA<TotalStreak>());
  });

  group('fromJson', () {
    test('should return a valid model when the JSON is recieved', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('home/daily_streak.json'));
      // act
      final result = TotalStreakModel.fromJson(jsonMap);
      // assert
      expect(result, totalStreak);
    });
  });
}
