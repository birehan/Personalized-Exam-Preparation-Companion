import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:skill_bridge_mobile/features/features.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final contestDetailModel = ContestDetailModel(
    contestId: '659e4f5d1b78560507eadd9d',
    title: 'Contest 4',
    description: '4th Contest',
    contestType: 'live',
    hasRegistered: false,
    hasEnded: false,
    isLive: false,
    startsAt: DateTime.parse('2024-01-12T06:00:00.000Z'),
    endsAt: DateTime.parse('2024-01-12T06:30:00.000Z'),
    isUpcoming: true,
    contestCategories: const [
      ContestCategoryModel(
        title: 'Biology Questions',
        subject: 'Biology',
        contestId: '659e4f5d1b78560507eadd9d',
        numberOfQuestion: 2,
        categoryId: '659e5b96f7f62073ac67cf33',
        isSubmitted: false,
        userScore: 0,
      ),
    ],
    contestPrizes: const [
      ContestPrizeModel(
        id: '659e619ad98ed340394305c0',
        description: 'First place Prize',
        standing: 1,
        type: 'cash',
        amount: 500,
      ),
    ],
    timeLeft: 0,
    userRank: 17,
    userScore: 0,
  );

  test('should be a subclass of ContestDetail entity.', () async {
    // assert
    expect(contestDetailModel, isA<ContestDetail>());
  });

  group('fromJson', () {
    test('should return a valid model when the JSON is received', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('contest/contest_detail.json'));
      // act
      final result = ContestDetailModel.fromJson(jsonMap);
      // assert
      expect(result, contestDetailModel);
    });

    group('toJson', () {});
  });
}
