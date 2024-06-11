import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prep_genie/features/features.dart';

import 'fetch_upcoming_user_contest_usecase_test.mocks.dart';

void main() {
  late MockContestRepository mockContestRepository;
  late FetchContestByIdUsecase usecase;

  setUp(() {
    mockContestRepository = MockContestRepository();
    usecase = FetchContestByIdUsecase(repository: mockContestRepository);
  });

  final contest = ContestModel(
    id: '6593b3b08a65e3bd7982fde9',
    title: 'Contest 2',
    description: 'First Contest',
    startsAt: DateTime.parse('2024-01-06T06:00:00.000Z'),
    endsAt: DateTime.parse('2024-01-06T06:30:00.000Z'),
    createdAt: DateTime.parse('2024-01-02T06:56:48.137Z'),
    live: true,
    hasRegistered: true,
    timeLeft: 120,
    liveRegister: 1,
    virtualRegister: 0,
  );
  test('should get contest by calling FetchContestByIdUsecase', () async {
    // arrange
    when(mockContestRepository.fetchContestById(
            contestId: '6593b3b08a65e3bd7982fde9'))
        .thenAnswer((_) async => Right(contest));
    // act
    final result = await usecase(
        const FetchContestByIdParams(contestId: '6593b3b08a65e3bd7982fde9'));
    // assert
    expect(result, Right(contest));
    verify(mockContestRepository.fetchContestById(
        contestId: '6593b3b08a65e3bd7982fde9'));
    verifyNoMoreInteractions(mockContestRepository);
  });
}
