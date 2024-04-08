import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:skill_bridge_mobile/features/features.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const contestPrizeModel = ContestPrizeModel(
    id: '659e619ad98ed340394305c0',
    description: 'First place Prize',
    standing: 1,
    type: 'cash',
    amount: 500,
  );

  test('should be a subclass of ContestPrize entity.', () async {
    // assert
    expect(contestPrizeModel, isA<ContestPrize>());
  });

  group('fromJson', () {
    test('should return a valid model when the JSON is received', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('contest/contest_prize.json'));
      // act
      final result = ContestPrizeModel.fromJson(jsonMap);
      // assert
      expect(result, contestPrizeModel);
    });

    group('toJson', () {});
  });
}
