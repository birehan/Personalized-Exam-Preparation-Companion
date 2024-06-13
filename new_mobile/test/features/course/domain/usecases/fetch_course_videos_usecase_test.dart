import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prep_genie/features/course/domain/entities/entities.dart';
import 'package:prep_genie/features/course/domain/usecases/fetch_course_videos_usecase.dart';

import 'get_user_courses_uscase_test.mocks.dart';

void main() {
  late FetchCourseVideosUsecase usecase;
  late MockCourseRepositories mockCourseRepository;

  setUp(() {
    mockCourseRepository = MockCourseRepositories();
    usecase =
        FetchCourseVideosUsecase(courseRepositories: mockCourseRepository);
  });

  const courseId = "id";
  const subChapterVideos = [
    SubchapterVideo(
        id: 'id',
        courseId: "courseId",
        chapterId: 'chapterId',
        subChapterId: 'subChapterId',
        order: 1,
        title: 'title',
        videoLink: 'videoLink',
        duration: "30 min",
        thumbnailUrl: "test thumbnail")
  ];
  const chapterVideos = [
    ChapterVideo(
        id: "id",
        description: "description",
        summary: "summary",
        courseId: "courseId",
        numberOfSubChapters: 1,
        title: 'title',
        order: 1,
        subchapterVideos: subChapterVideos)
  ];

  test(
    "Should get list of chapter videos from repository",
    () async {
      when(mockCourseRepository.fetchCourseVideos(courseId))
          .thenAnswer((_) async => const Right(chapterVideos));

      final result =
          await usecase.call(const FetchCourseVideoParams(courseId: courseId));

      expect(result, const Right(chapterVideos));

      verify(mockCourseRepository.fetchCourseVideos(courseId));

      verifyNoMoreInteractions(mockCourseRepository);
    },
  );
}
