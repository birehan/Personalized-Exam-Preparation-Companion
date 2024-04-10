import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:skill_bridge_mobile/core/error/failure.dart';
import 'package:skill_bridge_mobile/features/profile/domain/entities/consistency_entity.dart';
import 'package:skill_bridge_mobile/features/profile/domain/usecases/get_user_consistancy_data.dart';
import 'package:skill_bridge_mobile/features/profile/presentation/bloc/consistancyBloc/consistancy_bloc_bloc.dart';

import 'consistancy_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<GetUserConsistencyDataUsecase>()])
void main() {
  late ConsistancyBlocBloc bloc;
  late MockGetUserConsistencyDataUsecase mockGetUserConsistencyDataUsecase;

  setUp(() {
    mockGetUserConsistencyDataUsecase = MockGetUserConsistencyDataUsecase();
    bloc = ConsistancyBlocBloc(
        getUserConsistencyDataUsecase: mockGetUserConsistencyDataUsecase);
  });

  final consistancyData = [
    ConsistencyEntity(
        day: DateTime.now(),
        quizCompleted: 1,
        chapterCompleted: 1,
        subChapterCopleted: 1,
        mockCompleted: 1,
        questionCompleted: 1,
        overallPoint: 3),
    ConsistencyEntity(
        day: DateTime.now(),
        quizCompleted: 1,
        chapterCompleted: 1,
        subChapterCopleted: 1,
        mockCompleted: 1,
        questionCompleted: 1,
        overallPoint: 3),
    ConsistencyEntity(
        day: DateTime.now(),
        quizCompleted: 1,
        chapterCompleted: 1,
        subChapterCopleted: 1,
        mockCompleted: 1,
        questionCompleted: 1,
        overallPoint: 3),
  ];

  group('GetConsistencyData', () {
    test('should get data from the fetch the usecase', () async {
      // arrange
      when(mockGetUserConsistencyDataUsecase(any))
          .thenAnswer((_) async => Right(consistancyData));
      // act
      bloc.add(const GetUserConsistencyDataEvent(year: '2022', userId: '111'));

      await untilCalled(mockGetUserConsistencyDataUsecase(any));
      // assert
      verify(mockGetUserConsistencyDataUsecase(any));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () {
      // arrange
      when(mockGetUserConsistencyDataUsecase(any))
          .thenAnswer((_) async => Right(consistancyData));
      // assert later
      final expected = [
        ConsistancyLoadingState(),
        ConsistancyLoadedState(consistencyData: [consistancyData]),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const GetUserConsistencyDataEvent(year: '2022', userId: '111'));
    });
    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(mockGetUserConsistencyDataUsecase(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        ConsistancyLoadingState(),
        ConsistancyFailedState(failureType: ServerFailure()),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const GetUserConsistencyDataEvent(year: '2022', userId: '111'));
    });
  });
}
