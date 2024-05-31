import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:skill_bridge_mobile/core/error/failure.dart';
import 'package:skill_bridge_mobile/features/profile/domain/entities/department_entity.dart';
import 'package:skill_bridge_mobile/features/profile/domain/entities/school_entity.dart';
import 'package:skill_bridge_mobile/features/profile/domain/entities/school_info_enitity.dart';
import 'package:skill_bridge_mobile/features/profile/domain/usecases/get_school_info_usecase.dart';
import 'package:skill_bridge_mobile/features/profile/presentation/bloc/logout/logout_bloc.dart';
import 'package:skill_bridge_mobile/features/profile/presentation/bloc/schoolInfoBloc/school_bloc.dart';

import 'school_info_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<GetSchoolInfoUsecase>()])
void main() {
  late MockGetSchoolInfoUsecase mockGetSchoolInfoUsecase;

  setUp(() {
    mockGetSchoolInfoUsecase = MockGetSchoolInfoUsecase();
  });
  const departmentInfo = [
    DepartmentEntity(
        departmentId: 'departmentId', departmentName: 'departmentName'),
    DepartmentEntity(
        departmentId: 'departmentId', departmentName: 'departmentName'),
    DepartmentEntity(
        departmentId: 'departmentId', departmentName: 'departmentName'),
  ];
  const schoolInfo = [
    SchoolEntity(
        schoolId: 'schoolId', schoolName: 'schoolName', region: 'region'),
    SchoolEntity(
        schoolId: 'schoolId', schoolName: 'schoolName', region: 'region'),
    SchoolEntity(
        schoolId: 'schoolId', schoolName: 'schoolName', region: 'region'),
  ];
  const regionInfo = [
    'Gambella',
    'Addis Ababa',
    'Diredawa',
  ];
  const expectedSchoolInfo = SchoolDepartmentInfo(
    departmentInfo: departmentInfo,
    schoolInfo: schoolInfo,
    regionInfo: regionInfo,
  );
  blocTest<SchoolBloc, SchoolState>(
    'emits [SchoolLoadingState, SchoolLoadedState] GetSchoolInformationEvent when  successful',
    build: () => SchoolBloc(getSchoolInfoUsecase: mockGetSchoolInfoUsecase),
    act: (bloc) => bloc.add(GetSchoolInformationEvent()),
    setUp: () => when(mockGetSchoolInfoUsecase(any))
        .thenAnswer((_) async => const Right(expectedSchoolInfo)),
    expect: () => [
      SchoolLoadingState(),
      const SchoolLoadedState(schoolDepartmentInfo: expectedSchoolInfo),
    ],
    verify: (_) {
      verify(mockGetSchoolInfoUsecase(any)).called(1);
    },
  );
  blocTest<SchoolBloc, SchoolState>(
    'emits [SchoolLoadingState, SchoolFailedState] GetSchoolInformationEvent when  not successful',
    build: () => SchoolBloc(getSchoolInfoUsecase: mockGetSchoolInfoUsecase),
    act: (bloc) => bloc.add(GetSchoolInformationEvent()),
    setUp: () => when(mockGetSchoolInfoUsecase(any))
        .thenAnswer((_) async => Left(ServerFailure())),
    expect: () => [
      SchoolLoadingState(),
      SchoolFailedState(),
    ],
    verify: (_) {
      verify(mockGetSchoolInfoUsecase(any)).called(1);
    },
  );
}
