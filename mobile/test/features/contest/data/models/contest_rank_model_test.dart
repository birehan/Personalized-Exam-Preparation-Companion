import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:skill_bridge_mobile/core/core.dart';
import 'package:skill_bridge_mobile/features/features.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final contestRankModel = ContestRankModel(
    contestRankEntities: [
      ContestRankingModel(
        id: '65b8b71de23e1a61a61bbbff',
        contestId: '65b7687e6e350b2c0f1754e4',
        startsAt: DateTime.parse('2024-01-30T08:50:45.810Z'),
        endsAt: DateTime.parse('2024-01-30T08:58:14.424Z'),
        score: 14,
        type: 'live',
        userId: '65b20c7a411bc2d6ed31afd8',
        emailOrPhone: '+251987362330',
        firstName: 'Yohannes',
        lastName: 'Ketema',
        department: '64c24df185876fbb3f8dd6c7',
        avatar: defaultProfileAvatar,
      ),
    ],
    userRank: UserRankModel(
      rank: 1,
      contestRankEntity: ContestRankingModel(
        id: '65b8b71de23e1a61a61bbbff',
        contestId: '65b7687e6e350b2c0f1754e4',
        startsAt: DateTime.parse('2024-01-30T08:50:45.810Z'),
        endsAt: DateTime.parse('2024-01-30T08:58:14.424Z'),
        score: 14,
        type: 'live',
        userId: '65b20c7a411bc2d6ed31afd8',
        emailOrPhone: '+251987362330',
        firstName: 'Yohannes',
        lastName: 'Ketema',
        department: '64c24df185876fbb3f8dd6c7',
        avatar: defaultProfileAvatar,
      ),
    ),
  );

  test('should be a subclass of ContestRank entity.', () async {
    // assert
    expect(contestRankModel, isA<ContestRank>());
  });

  group('fromJson', () {
    test('should return a valid model when the JSON is received', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('contest/contest_rank.json'));
      // act
      final result = ContestRankModel.fromJson(jsonMap);
      // assert
      expect(result, contestRankModel);
    });

    group('toJson', () {});
  });
}