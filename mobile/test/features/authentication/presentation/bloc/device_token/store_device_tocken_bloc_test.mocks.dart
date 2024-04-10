// Mocks generated by Mockito 5.4.4 from annotations
// in skill_bridge_mobile/test/features/authentication/presentation/bloc/device_token/store_device_tocken_bloc_test.dart.
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

class _FakeAuthenticationRepository_0 extends _i1.SmartFake
    implements _i2.AuthenticationRepository {
  _FakeAuthenticationRepository_0(
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

/// A class which mocks [StoreDeviceTokenUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockStoreDeviceTokenUsecase extends _i1.Mock
    implements _i2.StoreDeviceTokenUsecase {
  @override
  _i2.AuthenticationRepository get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeAuthenticationRepository_0(
          this,
          Invocation.getter(#repository),
        ),
        returnValueForMissingStub: _FakeAuthenticationRepository_0(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i2.AuthenticationRepository);

  @override
  _i4.Future<_i3.Either<_i5.Failure, void>> call(_i5.NoParams? params) =>
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
