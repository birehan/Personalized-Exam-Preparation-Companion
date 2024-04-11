import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prepgenie/core/error/failure.dart';
import 'package:prepgenie/features/features.dart';

import 'fetch_course_videos_bloc_test.mocks.dart';


@GenerateNiceMocks([
  MockSpec<FetchCourseVideosUsecase>() 
])

void main() {
  late FetchCourseVideosBloc bloc;
  late MockFetchCourseVideosUsecase mockFetchCourseVideosUsecase;

  setUp(() {
    mockFetchCourseVideosUsecase = MockFetchCourseVideosUsecase();
    bloc = FetchCourseVideosBloc(fetchCourseVideosUsecase: mockFetchCourseVideosUsecase);
  });

  const courseId = "test course id";
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

  group('FetchCourseVideos', () {
    test('should get data from the fetch course videos usecase', () async {
      // arrange
      when(mockFetchCourseVideosUsecase(any))
          .thenAnswer((_) async => const Right(chapterVideos));
      // act
      bloc.add(const FetchCourseVideosEvent(courseId: courseId));

      await untilCalled(mockFetchCourseVideosUsecase(any));
      // assert
      verify(mockFetchCourseVideosUsecase(any));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () {
      // arrange
      when(mockFetchCourseVideosUsecase(any))
          .thenAnswer((_) async => const Right(chapterVideos));
      // assert later
      final expected = [
        FetchCourseVideosLoading(),
         FetchCourseVideosLoaded(chapterVideos: chapterVideos)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(FetchCourseVideosEvent(courseId: courseId));
    });
    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(mockFetchCourseVideosUsecase(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [FetchCourseVideosLoading(), const FetchCourseVideosFailed(errorMessage: "Server failure")];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(FetchCourseVideosEvent(courseId: courseId));
    });
    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      when(mockFetchCourseVideosUsecase(any)).thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [FetchCourseVideosLoading(), const FetchCourseVideosFailed(errorMessage:  'Cache failure')];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(FetchCourseVideosEvent(courseId: courseId));
    });
  });
}