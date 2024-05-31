import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:skill_bridge_mobile/features/profile/domain/entities/consistency_entity.dart';
import 'package:skill_bridge_mobile/features/profile/domain/usecases/get_user_consistancy_data.dart';

import 'get_profile_usecase_test.mocks.dart';

void main() {
  late GetUserConsistencyDataUsecase usecase;
  late MockProfileRepositories mockProfileRepository;

  setUp(() {
    mockProfileRepository = MockProfileRepositories();
    usecase = GetUserConsistencyDataUsecase(
      profileRepositories: mockProfileRepository,
    );
  });

  final tConsistencyParams = ConsistencyParams(year: '2022', userId: '111');
  final consistencyEntityList = [
    ConsistencyEntity(
        day: DateTime.now(),
        quizCompleted: 3,
        chapterCompleted: 3,
        subChapterCopleted: 3,
        mockCompleted: 3,
        questionCompleted: 3,
        overallPoint: 18),
  ];
  test(
    'should get consistency data from the repository',
    () async {
      // arrange
      when(mockProfileRepository.getUserConsistencyData(
        year: '2022',
        userId: '111',
      )).thenAnswer((_) async => Right(consistencyEntityList));

      // act
      final result = await usecase(tConsistencyParams);

      // assert
      expect(result, Right(consistencyEntityList));
      verify(mockProfileRepository.getUserConsistencyData(
        year: '2022',
        userId: '111',
      ));
      verifyNoMoreInteractions(mockProfileRepository);
    },
  );

//   test(
//     'should return a Failure when the repository call fails',
//     () async {
//      // arrange
//      when(mockProfileRepository.getUserConsistencyData(
//        year: anyNamed('year'),
//        userId: anyNamed('userId'),
//      )).thenAnswer((_) async => Left(ServerFailure()));

//      // act
//      final result = await usecase(tConsistencyParams);

//      // assert
//      expect(result, Left(ServerFailure()));
//      verify(mockProfileRepository.getUserConsistencyData(
//        year: '2022',
//        userId: null,
//      ));
//      verifyNoMoreInteractions(mockProfileRepository);
//    },
//  );
}
