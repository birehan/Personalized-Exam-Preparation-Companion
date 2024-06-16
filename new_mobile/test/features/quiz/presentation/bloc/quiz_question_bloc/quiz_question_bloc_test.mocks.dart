// Mocks generated by Mockito 5.4.4 from annotations
// in skill_bridge_mobile/test/features/quiz/presentation/bloc/quiz_question_bloc/quiz_question_bloc_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:dartz/dartz.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:prep_genie/core/core.dart' as _i5;
import 'package:prep_genie/features/features.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeQuizRepository_0 extends _i1.SmartFake
    implements _i2.QuizRepository {
  _FakeQuizRepository_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeEither_1<L, R> extends _i1.SmartFake implements _i3.Either<L, R> {
  _FakeEither_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [GetQuizByIdUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetQuizByIdUsecase extends _i1.Mock
    implements _i2.GetQuizByIdUsecase {
  @override
  _i2.QuizRepository get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeQuizRepository_0(
          this,
          Invocation.getter(#repository),
        ),
        returnValueForMissingStub: _FakeQuizRepository_0(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i2.QuizRepository);

  @override
  _i4.Future<_i3.Either<_i5.Failure, _i2.QuizQuestion>> call(
          _i2.GetQuizByIdParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue:
            _i4.Future<_i3.Either<_i5.Failure, _i2.QuizQuestion>>.value(
                _FakeEither_1<_i5.Failure, _i2.QuizQuestion>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i3.Either<_i5.Failure, _i2.QuizQuestion>>.value(
                _FakeEither_1<_i5.Failure, _i2.QuizQuestion>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
      ) as _i4.Future<_i3.Either<_i5.Failure, _i2.QuizQuestion>>);
}

/// A class which mocks [SaveQuizScoreUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockSaveQuizScoreUsecase extends _i1.Mock
    implements _i2.SaveQuizScoreUsecase {
  @override
  _i2.QuizRepository get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeQuizRepository_0(
          this,
          Invocation.getter(#repository),
        ),
        returnValueForMissingStub: _FakeQuizRepository_0(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i2.QuizRepository);

  @override
  _i4.Future<_i3.Either<_i5.Failure, void>> call(
          _i2.SaveQuizScoreParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue: _i4.Future<_i3.Either<_i5.Failure, void>>.value(
            _FakeEither_1<_i5.Failure, void>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i3.Either<_i5.Failure, void>>.value(
                _FakeEither_1<_i5.Failure, void>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
      ) as _i4.Future<_i3.Either<_i5.Failure, void>>);
}
