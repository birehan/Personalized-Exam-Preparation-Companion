import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prep_genie/features/course/domain/entities/course_image.dart';
import 'package:prep_genie/features/features.dart';

import 'get_user_courses_uscase_test.mocks.dart';

void main() {
  late GetDepartmentCourseUsecase usecase;
  late MockCourseRepositories mockCourseRepository;

  setUp(() {
    mockCourseRepository = MockCourseRepositories();
    usecase = GetDepartmentCourseUsecase(repository: mockCourseRepository);
  });

  const tId = "test id";
  const tCourse = [
    Course(
        id: "1",
        isNewCurriculum: true,
        departmentId: "dep_id",
        description: "test course description",
        ects: "10",
        grade: 12,
        image: CourseImage(imageAddress: "image address"),
        name: "test course name",
        numberOfChapters: 5,
        referenceBook: "test referance book")
  ];

  const departmentCourse = DepartmentCourse(
      biology: tCourse,
      chemistry: tCourse,
      civics: tCourse,
      english: tCourse,
      maths: tCourse,
      physics: tCourse,
      sat: tCourse,
      others: tCourse,
      economics: tCourse,
      history: tCourse,
      geography: tCourse,
      business: tCourse);

  test(
    "Should get list of user course from repository",
    () async {
      when(mockCourseRepository.getDepartmentCourse(tId))
          .thenAnswer((_) async => const Right(departmentCourse));

      final result = await usecase.call(DepartmentIdParams(id: tId));

      expect(result, const Right(departmentCourse));

      verify(mockCourseRepository.getDepartmentCourse(tId));

      verifyNoMoreInteractions(mockCourseRepository);
    },
  );
}