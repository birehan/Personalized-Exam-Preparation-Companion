import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:skill_bridge_mobile/features/course/domain/entities/course_image.dart';
import 'package:skill_bridge_mobile/features/features.dart';

import 'get_user_courses_uscase_test.mocks.dart';

void main() {
  late GetCoursesByDepartmentIdUseCase usecase;
  late MockCourseRepositories mockCourseRepository;

   setUp(() {
    mockCourseRepository = MockCourseRepositories();
    usecase = GetCoursesByDepartmentIdUseCase(courseRepositories: mockCourseRepository);
  });

  const tId = "test id";
  const tCourse = [Course(
      id: "1",
      cariculumIsNew: true,
      departmentId: "dep_id",
      description: "test course description",
      ects: "10",
      grade: 12,
      image: CourseImage(imageAddress: "image address"),
      name: "test course name",
      numberOfChapters: 5,
      referenceBook: "test referance book")];
  
  test(
    "Should get list of user course from repository",
    () async {
      when(mockCourseRepository.getCoursesByDepartmentId(tId))
          .thenAnswer((_) async => const Right(tCourse));

      final result = await usecase.call( DepartmentIdParams(id:tId));

      expect(result, const Right(tCourse));

      verify(mockCourseRepository.getCoursesByDepartmentId(tId));

      verifyNoMoreInteractions(mockCourseRepository);
    },
  );
}
