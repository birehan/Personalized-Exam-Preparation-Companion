// Mocks generated by Mockito 5.4.4 from annotations
// in skill_bridge_mobile/test/features/home/presentation/bloc/home/home_bloc_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:dartz/dartz.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:skill_bridge_mobile/core/core.dart' as _i5;
import 'package:skill_bridge_mobile/features/features.dart' as _i2;

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

class _FakeHomeRepository_0 extends _i1.SmartFake
    implements _i2.HomeRepository {
  _FakeHomeRepository_0(
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

/// A class which mocks [GetMyCoursesUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetMyCoursesUsecase extends _i1.Mock
    implements _i2.GetMyCoursesUsecase {
  @override
  _i2.HomeRepository get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeHomeRepository_0(
          this,
          Invocation.getter(#repository),
        ),
        returnValueForMissingStub: _FakeHomeRepository_0(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i2.HomeRepository);

  @override
  _i4.Future<_i3.Either<_i5.Failure, List<_i2.UserCourse>>> call(
          _i5.NoParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue:
            _i4.Future<_i3.Either<_i5.Failure, List<_i2.UserCourse>>>.value(
                _FakeEither_1<_i5.Failure, List<_i2.UserCourse>>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i3.Either<_i5.Failure, List<_i2.UserCourse>>>.value(
                _FakeEither_1<_i5.Failure, List<_i2.UserCourse>>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
      ) as _i4.Future<_i3.Either<_i5.Failure, List<_i2.UserCourse>>>);
}

/// A class which mocks [GetHomeUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetHomeUsecase extends _i1.Mock implements _i2.GetHomeUsecase {
  @override
  _i2.HomeRepository get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeHomeRepository_0(
          this,
          Invocation.getter(#repository),
        ),
        returnValueForMissingStub: _FakeHomeRepository_0(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i2.HomeRepository);

  @override
  _i4.Future<_i3.Either<_i5.Failure, _i2.HomeEntity>> call(
          _i2.GetHomeParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue: _i4.Future<_i3.Either<_i5.Failure, _i2.HomeEntity>>.value(
            _FakeEither_1<_i5.Failure, _i2.HomeEntity>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i3.Either<_i5.Failure, _i2.HomeEntity>>.value(
                _FakeEither_1<_i5.Failure, _i2.HomeEntity>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
      ) as _i4.Future<_i3.Either<_i5.Failure, _i2.HomeEntity>>);
}