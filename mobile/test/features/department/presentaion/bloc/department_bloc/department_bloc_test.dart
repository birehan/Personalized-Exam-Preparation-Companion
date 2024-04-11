import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:skill_bridge_mobile/core/error/failure.dart';
import 'package:skill_bridge_mobile/features/features.dart';

import 'department_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<GetAllGeneralDepartmentUsecase>()])
void main() {
  late DepartmentBloc bloc;
  late MockGetAllGeneralDepartmentUsecase mockGetAllGeneralDepartmentUsecase;

  setUp(() {
    mockGetAllGeneralDepartmentUsecase = MockGetAllGeneralDepartmentUsecase();
    bloc = DepartmentBloc(
        getAllGeneralDepartmentUsecase: mockGetAllGeneralDepartmentUsecase);
  });

  const department = [
    DepartmentModel(
        description: "description",
        generalDepartmentId: "id",
        id: "id",
        name: "name",
        numberOfCourses: 5)
  ];

  const generalDepartment = [
    GeneralDepartmentModel(
        id: "id",
        name: "name",
        description: "description",
        departments: department,
        isForListing: false)
  ];

  group('_onGetDepartment', () {
    test('should get data from fet all general department  usecase', () async {
      // arrange
      when(mockGetAllGeneralDepartmentUsecase(any))
          .thenAnswer((_) async => const Right(generalDepartment));
      // act
      bloc.add(GetDepartmentEvent());

      await untilCalled(mockGetAllGeneralDepartmentUsecase(any));
      // assert
      verify(mockGetAllGeneralDepartmentUsecase(any));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () {
      // arrange
      when(mockGetAllGeneralDepartmentUsecase(any))
          .thenAnswer((_) async => const Right(generalDepartment));
      // assert later
      final expected = [
        const GetDepartmentState(status: GetDepartmentStatus.loading),
        const GetDepartmentState(
            status: GetDepartmentStatus.loaded,
            generalDepartments: generalDepartment)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(GetDepartmentEvent());
    });
    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(mockGetAllGeneralDepartmentUsecase(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        const GetDepartmentState(status: GetDepartmentStatus.loading),
        const GetDepartmentState(status: GetDepartmentStatus.error)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(GetDepartmentEvent());
    });
    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      when(mockGetAllGeneralDepartmentUsecase(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        const GetDepartmentState(status: GetDepartmentStatus.loading),
        const GetDepartmentState(status: GetDepartmentStatus.error)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(GetDepartmentEvent());
    });
  });
}
