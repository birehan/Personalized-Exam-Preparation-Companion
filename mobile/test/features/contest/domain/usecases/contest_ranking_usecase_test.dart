import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:skill_bridge_mobile/features/contest/domain/usecases/contest_ranking_usercase.dart';
import 'package:skill_bridge_mobile/features/features.dart';

import 'fetch_upcoming_user_contest_usecase_test.mocks.dart';

void main() {
  late MockContestRepository mockContestRepository;
  late GetContestRankingUsecase usecase;

  final contestRank = ContestRank(
    contestRankEntities: [
      ContestRankEntity(
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
        avatar: '',
      ),
    ],
    userRank: UserRank(
      rank: 1,
      contestRankEntity: ContestRankEntity(
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
        avatar: '',
      ),
    ),
  );

  setUp(() {
    mockContestRepository = MockContestRepository();
    usecase =
        GetContestRankingUsecase(contestRepository: mockContestRepository);
  });

  test('should get contestRanking by calling GetContestRankingUsecase',
      () async {
    // arrange
    when(mockContestRepository.getContestRanking('65b7687e6e350b2c0f1754e4'))
        .thenAnswer((_) async => Right(contestRank));
    // act
    final result = await usecase(
        ContestRankingParams(contestId: '65b7687e6e350b2c0f1754e4'));
    // assert
    expect(result, Right(contestRank));
    verify(mockContestRepository.getContestRanking('65b7687e6e350b2c0f1754e4'));
    verifyNoMoreInteractions(mockContestRepository);
  });
}
