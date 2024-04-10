import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skill_bridge_mobile/features/features.dart';

import 'fetch_daily_quest_usecase_test.mocks.dart';
void main() {
  late GetHomeUsecase usecase;
  late MockHomeRepository mockHomeRepository;

  setUp(() {
    mockHomeRepository = MockHomeRepository();
    usecase = GetHomeUsecase(repository: mockHomeRepository);
  });

  const refresh = true;
  final date = DateTime.now();
  final examDates = [ExamDate(id: "id", date: date)];
  const homeMocks = [
    HomeMock(
        id: "id",
        name: "name",
        departmentId: "departmentId",
        examYear: "examYear",
        subject: "subject",
        numberOfQuestions: 50)
  ];
  const lastStartedChapter = HomeChapter(
      summary: "summary",
      id: "id",
      name: "name",
      description: 'description',
      courseId: "courseId",
      courseName: "courseName",
      noOfSubChapters: 5);
  final homeEntity = HomeEntity(
      lastStartedChapter: lastStartedChapter,
      examDates: examDates,
      homeMocks: homeMocks);

  test(
    "Should get home entity from repository",
    () async {
      when(mockHomeRepository.getHomeContent(refresh))
          .thenAnswer((_) async => Right(homeEntity));

      final result = await usecase.call(GetHomeParams(refresh: refresh));

      expect(result, Right(homeEntity));

      verify(mockHomeRepository.getHomeContent(refresh));

      verifyNoMoreInteractions(mockHomeRepository);
    },
  );
}
