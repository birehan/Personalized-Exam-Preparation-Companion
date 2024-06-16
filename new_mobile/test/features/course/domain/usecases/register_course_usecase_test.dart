import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prep_genie/features/features.dart';

import 'get_user_courses_uscase_test.mocks.dart';

void main() {
  late RegisterCourseUsecase usecase;
  late MockCourseRepositories mockCourseRepository;

  setUp(() {
    mockCourseRepository = MockCourseRepositories();
    usecase = RegisterCourseUsecase(courseRepositories: mockCourseRepository);
  });

  const tId = "test id";
  test(
    "Should get list of user course from repository",
    () async {
      when(mockCourseRepository.registerCourse(tId))
          .thenAnswer((_) async => Right(true));

      final result = await usecase.call(RegistrationParams(courseId: tId));

      expect(result, Right(true));

      verify(mockCourseRepository.registerCourse(tId));

      verifyNoMoreInteractions(mockCourseRepository);
    },
  );
}
