import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prep_genie/features/course/domain/usecases/register_sub_chapter_usecase.dart';

import 'get_user_courses_uscase_test.mocks.dart';

void main() {
  late RegisterSubChapterUsecase usecase;
  late MockCourseRepositories mockCourseRepository;

  setUp(() {
    mockCourseRepository = MockCourseRepositories();
    usecase =
        RegisterSubChapterUsecase(courseRepositories: mockCourseRepository);
  });

  const tSubChapter = "test sub chapter";
  const tChapterId = "test chapter id";

  test(
    "Should return true from the repository",
    () async {
      when(mockCourseRepository.registerSubChapter(tChapterId, tSubChapter))
          .thenAnswer((_) async => Right(true));

      final result = await usecase(SubChapterRegistrationParams(
          chapterId: tChapterId, subChapterid: tSubChapter));

      expect(result, Right(true));

      verify(mockCourseRepository.registerSubChapter(tChapterId, tSubChapter));

      verifyNoMoreInteractions(mockCourseRepository);
    },
  );
}
