import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prep_genie/core/error/failure.dart';
import 'package:prep_genie/features/features.dart';

import 'register_course_bloc_test.mocks.dart';

@GenerateNiceMocks([MockSpec<RegisterCourseUsecase>()])
void main() {
  late RegisterCourseBloc bloc;
  late MockRegisterCourseUsecase mockRegisterCourseUsecase;

  setUp(() {
    mockRegisterCourseUsecase = MockRegisterCourseUsecase();
    bloc = RegisterCourseBloc(registerCourseUsecase: mockRegisterCourseUsecase);
  });

  const id = "test id";

  group('Register course', () {
    test('should get data from the fetch course videos usecase', () async {
      // arrange
      when(mockRegisterCourseUsecase(any))
          .thenAnswer((_) async => const Right(true));
      // act
      bloc.add(const RegisterUserToACourse(courseId: id));

      await untilCalled(mockRegisterCourseUsecase(any));
      // assert
      verify(mockRegisterCourseUsecase(any));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully', () {
      // arrange
      when(mockRegisterCourseUsecase(any))
          .thenAnswer((_) async => const Right(true));
      // assert later
      final expected = [CourseRegisteringState(), UserRegisteredState()];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(RegisterUserToACourse(courseId: id));
    });
    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(mockRegisterCourseUsecase(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        CourseRegisteringState(),
        CourseRegistrationFailedState()
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(RegisterUserToACourse(courseId: id));
    });
    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      when(mockRegisterCourseUsecase(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        CourseRegisteringState(),
        CourseRegistrationFailedState()
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(RegisterUserToACourse(courseId: id));
    });
  });
}
