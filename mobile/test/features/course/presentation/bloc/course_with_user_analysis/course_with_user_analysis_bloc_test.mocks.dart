// Mocks generated by Mockito 5.4.4 from annotations
// in skill_bridge_mobile/test/features/course/presentation/bloc/course_with_user_analysis/course_with_user_analysis_bloc_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:dartz/dartz.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:prepgenie/core/core.dart' as _i5;
import 'package:prepgenie/features/course/domain/domain.dart' as _i2;

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

class _FakeCourseRepositories_0 extends _i1.SmartFake
    implements _i2.CourseRepositories {
  _FakeCourseRepositories_0(
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

/// A class which mocks [GetCourseWithAnalysisUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetCourseWithAnalysisUsecase extends _i1.Mock
    implements _i2.GetCourseWithAnalysisUsecase {
  @override
  _i2.CourseRepositories get courseRepository => (super.noSuchMethod(
        Invocation.getter(#courseRepository),
        returnValue: _FakeCourseRepositories_0(
          this,
          Invocation.getter(#courseRepository),
        ),
        returnValueForMissingStub: _FakeCourseRepositories_0(
          this,
          Invocation.getter(#courseRepository),
        ),
      ) as _i2.CourseRepositories);

  @override
  _i4.Future<_i3.Either<_i5.Failure, _i2.UserCourseAnalysis>> call(
          _i2.CourseIdParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue:
            _i4.Future<_i3.Either<_i5.Failure, _i2.UserCourseAnalysis>>.value(
                _FakeEither_1<_i5.Failure, _i2.UserCourseAnalysis>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i3.Either<_i5.Failure, _i2.UserCourseAnalysis>>.value(
                _FakeEither_1<_i5.Failure, _i2.UserCourseAnalysis>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
      ) as _i4.Future<_i3.Either<_i5.Failure, _i2.UserCourseAnalysis>>);
}
