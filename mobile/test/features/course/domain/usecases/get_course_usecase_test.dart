import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prepgenie/features/chapter/domain/entities/sub_chapters_list.dart';
import 'package:prepgenie/features/course/domain/entities/course_image.dart';
import 'package:prepgenie/features/features.dart';

import 'get_user_courses_uscase_test.mocks.dart';

void main() {
  late GetCourseWithAnalysisUsecase usecase;
  late MockCourseRepositories mockCourseRepository;

  setUp(() {
    mockCourseRepository = MockCourseRepositories();
    usecase = GetCourseWithAnalysisUsecase(mockCourseRepository);
  });

  const tId = "test id";
  const tCourse = Course(
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

  const tChapter = Chapter(
      noOfSubchapters: 2,
      id: "id",
      courseId: "courseId",
      name: "name",
      description: "description",
      summary: "summary",
      order: 1);

  // const tContent = [Content(content: "content", id: "id", subChapterId: "sub chapter id", title: "title", isBookmarked: true)];
  const tSubChapters = [
    SubChapterList(
        id: "id",
        chapterId: "chapter id",
        subChapterName: "name",
        isCompleted: true)
  ];

  const userChaptersAnalysis = [
    UserChapterAnalysis(
        id: "id",
        chapter: tChapter,
        completedSubChapters: 2,
        subchapters: tSubChapters)
  ];

  const userCourseAnalysis = UserCourseAnalysis(
      course: tCourse, userChaptersAnalysis: userChaptersAnalysis);

  test(
    "Should get list of user course analysis from repository",
    () async {
      when(mockCourseRepository.getCourseById(id: tId, isRefreshed: true))
          .thenAnswer((_) async => const Right(userCourseAnalysis));

      final result =
          await usecase.call(const CourseIdParams(id: tId, isRefreshed: true));

      expect(result, const Right(userCourseAnalysis));

      verify(mockCourseRepository.getCourseById(id: tId, isRefreshed: true));

      verifyNoMoreInteractions(mockCourseRepository);
    },
  );
}
