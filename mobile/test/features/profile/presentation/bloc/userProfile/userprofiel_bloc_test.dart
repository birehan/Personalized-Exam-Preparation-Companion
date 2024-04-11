import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prepgenie/core/error/failure.dart';
import 'package:prepgenie/features/features.dart';
import 'package:prepgenie/features/profile/presentation/bloc/userProfile/userProfile_bloc.dart';
import 'package:prepgenie/features/profile/presentation/bloc/userProfile/userProfile_event.dart';
import 'package:prepgenie/features/profile/presentation/bloc/userProfile/userProfile_state.dart';

import 'userprofiel_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<GetProfileUsecase>()])
void main() {
  late MockGetProfileUsecase mockGetProfileUsecase;
  setUp(() {
    mockGetProfileUsecase = MockGetProfileUsecase();
  });
  const userProfile = UserProfile(
      firstName: 'abe',
      lastName: 'kebe',
      email: 'abekebe@gmail.com',
      profileImage: 'profileImage',
      topicsCompleted: 1,
      chaptersCompleted: 1,
      questionsSolved: 1,
      totalScore: 10,
      rank: 100,
      points: 200,
      currentStreak: 3,
      maxStreak: 3,
      consistecy: [],
      examType: 'examType',
      howPrepared: 'howPrepared',
      preferedMethod: 'preferedMethod',
      studyTimePerDay: 'studyTimePerDay',
      motivation: 'motivation',
      reminder: 'reminder',
      departmentId: 'departmentId',
      departmentName: 'departmentName');
  blocTest<UserProfileBloc, UserProfileState>(
    'emits [ProfileLoading, ProfileLoaded] GetProfileUsecase when  called for first page',
    build: () => UserProfileBloc(getProfileUsecase: mockGetProfileUsecase),
    act: (bloc) => bloc.add(GetUserProfile(isRefreshed: false, userId: '111')),
    setUp: () => when(mockGetProfileUsecase(any))
        .thenAnswer((_) async => const Right(userProfile)),
    expect: () => [
      ProfileLoading(),
      const ProfileLoaded(userProfile: userProfile),
    ],
    verify: (_) {
      verify(mockGetProfileUsecase(any)).called(1);
    },
  );

  blocTest<UserProfileBloc, UserProfileState>(
    'emits [ProfileLoading, ProfileFailedState] GetProfileUsecase returened error',
    build: () => UserProfileBloc(getProfileUsecase: mockGetProfileUsecase),
    act: (bloc) => bloc.add(GetUserProfile(isRefreshed: false, userId: '111')),
    setUp: () => when(mockGetProfileUsecase(any))
        .thenAnswer((_) async => Left(ServerFailure(errorMessage: 'error'))),
    expect: () => [
      ProfileLoading(),
      ProfileFailedState(failure: ServerFailure(), errorMessage: 'error'),
    ],
    verify: (_) {
      verify(mockGetProfileUsecase(any)).called(1);
    },
  );
}
