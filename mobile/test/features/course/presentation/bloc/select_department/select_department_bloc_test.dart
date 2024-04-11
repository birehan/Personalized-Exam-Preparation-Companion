import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prepgenie/core/error/failure.dart';
import 'package:prepgenie/features/features.dart';

import 'select_department_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<GetAllGeneralDepartmentUsecase>()])
void main() {
  late SelectDepartmentBloc bloc;
  late MockGetAllGeneralDepartmentUsecase mockCourseByDepartmentIdUseCase;

  setUp(() {
    mockCourseByDepartmentIdUseCase = MockGetAllGeneralDepartmentUsecase();
    bloc = SelectDepartmentBloc(
        getAllGeneralDepartmentUsecase: mockCourseByDepartmentIdUseCase);
  });
  const departments = [
    Department(
        id: "id",
        name: "name",
        description: "description",
        numberOfCourses: 4,
        generalDepartmentId: "generalDepartmentId")
  ];
  const generalDepartment = [
    GeneralDepartment(
        id: "test id",
        name: "name",
        description: "description",
        departments: departments,
        isForListing: false)
  ];

  group('Select Department', () {
    test(
        'should get data from the fetch all department by general department Id usecase',
        () async {
      // arrange
      when(mockCourseByDepartmentIdUseCase(any))
          .thenAnswer((_) async => const Right(generalDepartment));
      // act
      bloc.add(GetAllDepartmentsEvent());

      await untilCalled(mockCourseByDepartmentIdUseCase(any));
      // assert
      verify(mockCourseByDepartmentIdUseCase(any));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () {
      // arrange
      when(mockCourseByDepartmentIdUseCase(any))
          .thenAnswer((_) async => const Right(generalDepartment));
      // assert later
      final expected = [
        AllDepartmentsLoadingState(),
        const AllDepartmentsLoadedState(generalDepartments: generalDepartment)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(GetAllDepartmentsEvent());
    });
    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(mockCourseByDepartmentIdUseCase(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        AllDepartmentsLoadingState(),
        const AllDepartmentsFailedState(message: "Server Faliure")
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add( GetAllDepartmentsEvent());
    });
    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      when(mockCourseByDepartmentIdUseCase(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        AllDepartmentsLoadingState(),
        const AllDepartmentsFailedState(message: "Cache Faliure")
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(GetAllDepartmentsEvent());
    });
  });
}
