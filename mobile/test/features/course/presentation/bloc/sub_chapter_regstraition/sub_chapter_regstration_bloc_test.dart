import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prepgenie/core/error/failure.dart';
import 'package:prepgenie/features/features.dart';

import 'sub_chapter_regstration_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<RegisterSubChapterUsecase>()])
void main() {
  late SubChapterRegstrationBloc bloc;
  late MockRegisterSubChapterUsecase mockRegisterSubChapterUsecase;

  setUp(() {
    mockRegisterSubChapterUsecase = MockRegisterSubChapterUsecase();
    bloc = SubChapterRegstrationBloc(
        registerSubChapterUsecase: mockRegisterSubChapterUsecase);
  });

  const tSubChapter = "test sub chapter";
  const tChapterId = "test chapter id";

  group('Register sub chapter', () {
    test('should get data from the fetch subchapter usecase', () async {
      // arrange
      when(mockRegisterSubChapterUsecase(any))
          .thenAnswer((_) async => const Right(true));
      // act
      bloc.add(const ResgisterSubChpaterEvent(
          chapterId: tChapterId, subChapterid: tSubChapter));

      await untilCalled(mockRegisterSubChapterUsecase(any));
      // assert
      verify(mockRegisterSubChapterUsecase(any));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () {
      // arrange
      when(mockRegisterSubChapterUsecase(any))
          .thenAnswer((_) async => const Right(true));
      // assert later
      final expected = [SubChapterRegstrationLoadingState(), SubChapterRegstrationSuccessState()];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const ResgisterSubChpaterEvent(
          chapterId: tChapterId, subChapterid: tSubChapter));
    });
    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(mockRegisterSubChapterUsecase(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        SubChapterRegstrationLoadingState(),
        SubChapterRegstrationFailedState()
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const ResgisterSubChpaterEvent(
          chapterId: tChapterId, subChapterid: tSubChapter));
    });
    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      when(mockRegisterSubChapterUsecase(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        SubChapterRegstrationLoadingState(),
        SubChapterRegstrationFailedState()
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const ResgisterSubChpaterEvent(
          chapterId: tChapterId, subChapterid: tSubChapter));
    });
  });
}
