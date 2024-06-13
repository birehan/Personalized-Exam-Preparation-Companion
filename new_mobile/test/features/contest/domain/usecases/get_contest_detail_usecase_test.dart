import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prep_genie/features/features.dart';

import 'package:prep_genie/features/contest/domain/usecases/get_contest_detail_usecase.dart';
import 'fetch_upcoming_user_contest_usecase_test.mocks.dart';

void main() {
  late MockContestRepository mockContestRepository;
  late GetContestDetailUsecase usecase;

  setUp(() {
    mockContestRepository = MockContestRepository();
    usecase = GetContestDetailUsecase(contestRepository: mockContestRepository);
  });

  final contestDetail = ContestDetail(
    contestId: '659e4f5d1b78560507eadd9d',
    isUpcoming: true,
    hasRegistered: false,
    hasEnded: false,
    contestType: 'live',
    userScore: 0,
    startsAt: DateTime.parse('2024-01-12T06:00:00.000Z'),
    endsAt: DateTime.parse('2024-01-12T06:30:00.000Z'),
    contestPrizes: const [
      ContestPrize(
          description: 'First place Prize',
          standing: 1,
          type: 'cash',
          amount: 500,
          id: '659e619ad98ed340394305c0'),
    ],
    contestCategories: const [
      ContestCategory(
        title: 'Biology Questions',
        subject: 'Biology',
        contestId: '659e4f5d1b78560507eadd9d',
        numberOfQuestion: 2,
        categoryId: '659e5b96f7f62073ac67cf33',
        isSubmitted: false,
        userScore: 0,
      ),
    ],
    description: '4th Contest',
    title: 'Contest 4',
    timeLeft: 0,
    userRank: 17,
    isLive: false,
  );

  test('should get contesDetail by calling GetContestDetailUsecase', () async {
    // arrange
    when(mockContestRepository.getContestDetail('659e4f5d1b78560507eadd9d'))
        .thenAnswer((_) async => Right(contestDetail));
    // act
    final result = await usecase(
        ContestDetailParams(contestId: '659e4f5d1b78560507eadd9d'));
    // assert
    expect(result, Right(contestDetail));
    verify(mockContestRepository.getContestDetail('659e4f5d1b78560507eadd9d'));
    verifyNoMoreInteractions(mockContestRepository);
  });
}
