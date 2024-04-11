import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prepgenie/core/error/failure.dart';
import 'package:prepgenie/features/chapter/domain/entities/sub_chapters_list.dart';
import 'package:prepgenie/features/course/domain/entities/course_image.dart';
import 'package:prepgenie/features/features.dart';

import 'course_with_user_analysis_bloc_test.mocks.dart';


@GenerateNiceMocks([
  MockSpec<GetCourseWithAnalysisUsecase>() 
])

void main() {
  late CourseWithUserAnalysisBloc bloc;
  late MockGetCourseWithAnalysisUsecase mockGetCourseWithAnalysisUsecase;
  

  setUp(() {
    mockGetCourseWithAnalysisUsecase = MockGetCourseWithAnalysisUsecase();
    bloc = CourseWithUserAnalysisBloc(getCourseUsecase: mockGetCourseWithAnalysisUsecase);
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
  
  const tChapter = Chapter(noOfSubchapters: 2, id: "id", courseId: "courseId", name: "name", description: "description", summary: "summary", order: 1);

  // const tContent = [Content(content: "content", id: "id", subChapterId: "sub chapter id", title: "title", isBookmarked: true)];
  const tSubChapters = [SubChapterList(id: "id", chapterId: "chapter id", subChapterName: "name", isCompleted: true)];

  const userChaptersAnalysis = [UserChapterAnalysis(id: "id", chapter: tChapter, completedSubChapters: 2, subchapters: tSubChapters)];

  final userCourseAnalysis = UserCourseAnalysis(course: tCourse, userChaptersAnalysis: userChaptersAnalysis);

  group('GetCourseByIdEvent', () {
    test('should get data from the fetch course user analysis usecase', () async {
      // arrange
      when(mockGetCourseWithAnalysisUsecase(any))
          .thenAnswer((_) async =>  Right(userCourseAnalysis));
      // act
      bloc.add( GetCourseByIdEvent(id: tId, isRefreshed: false));

      await untilCalled(mockGetCourseWithAnalysisUsecase(any));
      // assert
      verify(mockGetCourseWithAnalysisUsecase(any));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () {
      // arrange
      when(mockGetCourseWithAnalysisUsecase(any))
          .thenAnswer((_) async =>  Right(userCourseAnalysis));
      // assert later
      final expected = [
        CourseLoadingState(),
        CourseLoadedState(userCourseAnalysis: userCourseAnalysis)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(GetCourseByIdEvent(id: tId, isRefreshed: false));
    });
    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(mockGetCourseWithAnalysisUsecase(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [CourseLoadingState(),  CourseErrorState(failure: ServerFailure(), message: "Server Failure")];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(GetCourseByIdEvent(id: tId, isRefreshed: false));
    });
    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      when(mockGetCourseWithAnalysisUsecase(any)).thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [CourseLoadingState(), CourseErrorState(failure: CacheFailure(), message: "Cache Failure")];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(GetCourseByIdEvent(id: tId, isRefreshed: false));
    });
  });
}