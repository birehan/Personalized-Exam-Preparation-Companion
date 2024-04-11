import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prepgenie/core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prepgenie/features/features.dart';

import 'get_all_general_department_usecase_test.mocks.dart';

@GenerateNiceMocks([MockSpec<DepartmentRepository>()])
void main() {
  late GetAllGeneralDepartmentUsecase usecase;
  late MockDepartmentRepository mockCourseRepository;

  setUp(() {
    mockCourseRepository = MockDepartmentRepository();
    usecase = GetAllGeneralDepartmentUsecase(repository: mockCourseRepository);
  });

  const departments = [
    Department(
        id: "id",
        name: "name",
        description: "description",
        numberOfCourses: 5,
        generalDepartmentId: "id")
  ];
  const generalDepartments = [
    GeneralDepartment(
        id: "id",
        name: "name",
        description: "description",
        departments: departments,
        isForListing: false)
  ];

  test(
    "Should get list of all general departments from repository",
    () async {
      when(mockCourseRepository.getAllDepartments())
          .thenAnswer((_) async => const Right(generalDepartments));

      final result = await usecase.call(NoParams());

      expect(result, const Right(generalDepartments));

      verify(mockCourseRepository.getAllDepartments());

      verifyNoMoreInteractions(mockCourseRepository);
    },
  );
}
