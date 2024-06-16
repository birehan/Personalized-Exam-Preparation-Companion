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
}
