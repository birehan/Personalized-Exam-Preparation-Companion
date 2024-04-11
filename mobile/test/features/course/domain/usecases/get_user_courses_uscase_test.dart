import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:skill_bridge_mobile/features/course/domain/entities/course_image.dart';
import 'package:skill_bridge_mobile/features/course/domain/entities/entities.dart';
import 'package:skill_bridge_mobile/features/course/domain/repositories/course_repositories.dart';
import 'package:skill_bridge_mobile/features/course/domain/usecases/get_user_courses_usecases.dart';
import 'package:flutter_test/flutter_test.dart';

import 'get_user_courses_uscase_test.mocks.dart';


@GenerateNiceMocks([MockSpec<CourseRepositories>()])
void main() {
  late UserCoursesUseCase usecase;
  late MockCourseRepositories mockCourseRepository;

  setUp(() {
    mockCourseRepository = MockCourseRepositories();
    usecase = UserCoursesUseCase(courseRepositories: mockCourseRepository);
  });

  bool refresh = false;
  final tCourse = Course(
      id: "1",
      cariculumIsNew: true,
      departmentId: "dep_id",
      description: "test course description",
      ects: "10",
      grade: 12,
      image: CourseImage(imageAddress: "image address"),
      name: "test course name",
      numberOfChapters: 5,
      referenceBook: "test referance book");
  final tUserCourse = [
    UserCourse(
        id: "test user course id",
        userId: "test user id",
        course: tCourse,
        completedChapters: 1)
  ];

  test(
    "Should get list of user course from repository",
    () async {
      when(mockCourseRepository.getUserCourses(refresh))
          .thenAnswer((_) async => Right(tUserCourse));

      final result = await usecase.call(UserCoursesParams(refresh: refresh));

      expect(result, Right(tUserCourse));

      verify(mockCourseRepository.getUserCourses(refresh));

      verifyNoMoreInteractions(mockCourseRepository);
    },
  );
}
