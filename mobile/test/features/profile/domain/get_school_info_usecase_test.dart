import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prepgenie/core/usecase/usecase.dart';
import 'package:prepgenie/features/profile/domain/entities/department_entity.dart';
import 'package:prepgenie/features/profile/domain/entities/school_entity.dart';
import 'package:prepgenie/features/profile/domain/entities/school_info_enitity.dart';
import 'package:prepgenie/features/profile/domain/usecases/get_school_info_usecase.dart';

import 'get_profile_usecase_test.mocks.dart';

void main() {
  late GetSchoolInfoUsecase usecase;
  late MockProfileRepositories mockProfileRepository;

  setUp(() {
    mockProfileRepository = MockProfileRepositories();
    usecase = GetSchoolInfoUsecase(profileRepositories: mockProfileRepository);
  });

  test('should get school info from the repository', () async {
    // arrange
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

    when(mockProfileRepository.getSchoolInfo())
        .thenAnswer((_) async => const Right(expectedSchoolInfo));

    // act
    final result = await usecase(NoParams());

    // assert
    expect(result, const Right(expectedSchoolInfo));
    verify(mockProfileRepository.getSchoolInfo());
    verifyNoMoreInteractions(mockProfileRepository);
  });

  // test('should return a failure when getting school info fails', () async {
  //   // arrange
  //   when(mockProfileRepository.getSchoolInfo())
  //       .thenAnswer((_) async => Left(ServerFailure()));

  //   // act
  //   final result = await usecase(NoParams());

  //   // assert
  //   expect(result, Left(ServerFailure()));
  //   verify(mockProfileRepository.getSchoolInfo());
  //   verifyNoMoreInteractions(mockProfileRepository);
  // });
}
