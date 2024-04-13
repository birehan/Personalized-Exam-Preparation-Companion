import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prepgenie/core/error/failure.dart';
import 'package:prepgenie/features/home/domain/entities/exam_date.dart';
import 'package:prepgenie/features/home/domain/usecases/get_exam_date_usecase.dart';
import 'package:prepgenie/features/home/presentation/bloc/exam_date/exam_date_bloc.dart';

import 'exam_date_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<GetExamDateUsecase>()])
void main() {
  late GetExamDateBloc bloc;
  late MockGetExamDateUsecase mockGetExamDateUsecase;

  setUp(() {
    mockGetExamDateUsecase = MockGetExamDateUsecase();
    bloc = GetExamDateBloc(getExamDateUsecase: mockGetExamDateUsecase);
  });

  final date = DateTime.now();
  final examDates = [ExamDate(id: "id", date: date)];

  group('_onGetExamDate', () {
    test('should get data from the get exam date usecase', () async {
      // arrange
      when(mockGetExamDateUsecase(any))
          .thenAnswer((_) async =>  Right(examDates));
      // act
      bloc.add(ExamDateEvent());

      await untilCalled(mockGetExamDateUsecase(any));
      // assert
      verify(mockGetExamDateUsecase(any));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () {
      // arrange
      when(mockGetExamDateUsecase(any))
          .thenAnswer((_) async =>  Right(examDates));
      // assert later
      final expected = [
        const ExamDateState(status: GetExamDateStatus.loading),
         ExamDateState(
            status: GetExamDateStatus.loaded,
            targetDate: examDates[0]
           )
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(ExamDateEvent());
    });
    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(mockGetExamDateUsecase(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        const ExamDateState(status: GetExamDateStatus.loading),
        const ExamDateState(status: GetExamDateStatus.error)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(ExamDateEvent());
    });
    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      when(mockGetExamDateUsecase(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        const ExamDateState(status: GetExamDateStatus.loading),
        const ExamDateState(status: GetExamDateStatus.error)
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(ExamDateEvent());
    });
  });
}
