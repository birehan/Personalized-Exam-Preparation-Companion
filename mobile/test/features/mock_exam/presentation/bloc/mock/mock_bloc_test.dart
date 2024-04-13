import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prepgenie/core/error/failure.dart';
import 'package:prepgenie/features/mock_exam/mock_exam.dart';

import 'mock_bloc_test.mocks.dart';

@GenerateNiceMocks(
    [MockSpec<GetDepartmentMocksUsecase>(), MockSpec<GetMockExamsUsecase>()])
void main() {
  late MockExamBloc bloc;
  late MockGetDepartmentMocksUsecase mockGetDepartmentMocksUsecase;
  late MockGetMockExamsUsecase mockExamsUsecase;

  setUp(() {
    mockGetDepartmentMocksUsecase = MockGetDepartmentMocksUsecase();
    mockExamsUsecase = MockGetMockExamsUsecase();
    bloc = MockExamBloc(
        getDepartmentMocksUsecase: mockGetDepartmentMocksUsecase,
        getMockExamsUsecase: mockExamsUsecase);
  });

  const tId = "English";
  const mockExams = [
    MockExamModel(
        id: "65409e6055ae50031e35167f",
        name: "English Entrance Exam",
        departmentId: "64c24df185876fbb3f8dd6c7",
        examYear: "2013",
        numberOfQuestions: 120)
  ];

  const departmentMock = DepartmentMockModel(id: tId, mockExams: mockExams);

  group('_onGetMocks', () {
    test('should get data from the get department mocks usecase', () async {
      // arrange
      when(mockExamsUsecase(any))
          .thenAnswer((_) async => const Right(mockExams));
      // act
      bloc.add(const GetMocksEvent(isRefreshed: false));

      await untilCalled(mockExamsUsecase(any));
      // assert
      verify(mockExamsUsecase(any));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () {
      // arrange
      when(mockExamsUsecase(any))
          .thenAnswer((_) async => const Right(mockExams));
      // assert later
      final expected = [
        const GetMocksState(status: MockExamStatus.loading),
        const GetMocksState(status: MockExamStatus.loaded, mockExams: mockExams)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const GetMocksEvent(isRefreshed: false));
    });
    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(mockExamsUsecase(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        const GetMocksState(status: MockExamStatus.loading),
        const GetMocksState(status: MockExamStatus.error)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const GetMocksEvent(isRefreshed: false));
    });
    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      when(mockExamsUsecase(any)).thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        const GetMocksState(status: MockExamStatus.loading),
        const GetMocksState(status: MockExamStatus.error)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const GetMocksEvent(isRefreshed: false));
    });
  });

  group('_onGetDepartmentMocks', () {
    test('should get data from the get department mocks usecase', () async {
      // arrange
      when(mockGetDepartmentMocksUsecase(any))
          .thenAnswer((_) async => const Right([departmentMock]));
      // act
      bloc.add(const GetDepartmentMocksEvent(
          departmentId: tId, isRefreshed: false, isStandard: true));

      await untilCalled(mockGetDepartmentMocksUsecase(any));
      // assert
      verify(mockGetDepartmentMocksUsecase(any));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () {
      // arrange
      when(mockGetDepartmentMocksUsecase(any))
          .thenAnswer((_) async => const Right([departmentMock]));
      // assert later
      final expected = [
        const GetDepartmentMocksState(status: MockExamStatus.loading),
        const GetDepartmentMocksState(
            status: MockExamStatus.loaded, departmentMocks: [departmentMock])
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const GetDepartmentMocksEvent(
          departmentId: tId, isRefreshed: false, isStandard: true));
    });
    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(mockGetDepartmentMocksUsecase(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        const GetDepartmentMocksState(status: MockExamStatus.loading),
        const GetDepartmentMocksState(status: MockExamStatus.error)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const GetDepartmentMocksEvent(
          departmentId: tId, isRefreshed: false, isStandard: true));
    });
    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      when(mockGetDepartmentMocksUsecase(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        const GetDepartmentMocksState(status: MockExamStatus.loading),
        const GetDepartmentMocksState(status: MockExamStatus.error)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const GetDepartmentMocksEvent(
          departmentId: tId, isRefreshed: false, isStandard: true));
    });
  });
}
