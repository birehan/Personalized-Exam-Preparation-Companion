import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prepgenie/core/core.dart';
import 'package:prepgenie/features/features.dart';

import 'fetch_upcoming_user_contest_usecase_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ContestRepository>()
])
void main(){
  late MockContestRepository  mockContestRepository;
  late FetchUpcomingUserContestUsecase usecase;


  setUp(() {
    mockContestRepository = MockContestRepository();
    usecase = FetchUpcomingUserContestUsecase(repository: mockContestRepository);
  });

  final upcomingContest = ContestModel(id: '_id', title: 'title', description: 'description', startsAt: DateTime.now(), endsAt: DateTime.now(), createdAt: DateTime.now(), live: true, hasRegistered: true, timeLeft: 120, liveRegister: 1, virtualRegister: 0,);

  test('should get upcomingContest by calling FetchUpcomingUserContestUsecase', () async {
    // arrange
    when(mockContestRepository.fetchUpcomingUserContest()).thenAnswer((_) async => Right(upcomingContest as ContestModel?));
    // act
    final result = await usecase(NoParams());
    // assert
    expect(result, Right(upcomingContest));
    verify(mockContestRepository.fetchUpcomingUserContest());
    verifyNoMoreInteractions(mockContestRepository);
  });  

}