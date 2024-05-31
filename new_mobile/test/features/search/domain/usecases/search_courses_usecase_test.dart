import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:skill_bridge_mobile/features/course/domain/entities/course.dart';
import 'package:skill_bridge_mobile/features/course/domain/entities/course_image.dart';
import 'package:skill_bridge_mobile/features/search/domain/domain.dart';
import 'package:skill_bridge_mobile/features/search/domain/repositories/search_repository.dart';

import 'search_courses_usecase_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<SearchRepository>(),
])
void main() {
  late MockSearchRepository searchRepository;
  late SearchCoursesUsecase searchCoursesUsecase;
  setUp(() {
    searchRepository = MockSearchRepository();
    searchCoursesUsecase = SearchCoursesUsecase(searchRepository);
  });
  const tCourse = Course(
      id: "1",
      isNewCurriculum: true,
      departmentId: "dep_id",
      description: "test course description",
      ects: "10",
      grade: 12,
      image: CourseImage(imageAddress: "image address"),
      name: "test course name",
      numberOfChapters: 5,
      referenceBook: "test referance book");
  const courses = [tCourse, tCourse, tCourse];

  test(
    "Should save courses on search",
    () async {
      when(searchRepository.searchCourses('111'))
          .thenAnswer((_) async => const Right(courses));

      final result = await searchCoursesUsecase
          .call(const SearchCourseQueryParams(query: '111'));

      expect(result, const Right(courses));

      verify(searchRepository.searchCourses('111')).called(1);
    },
  );
}
