// Mocks generated by Mockito 5.4.4 from annotations
// in skill_bridge_mobile/test/features/authentication/presentation/bloc/authentication_bloc/authentication_bloc_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:dartz/dartz.dart' as _i3;
import 'package:firebase_auth/firebase_auth.dart' as _i8;
import 'package:mockito/mockito.dart' as _i1;
import 'package:prepgenie/core/core.dart' as _i6;
import 'package:prepgenie/features/authentication/domain/entities/user_credential.dart'
    as _i7;
import 'package:prepgenie/features/authentication/domain/repositories/authentication_repository.dart'
    as _i2;
import 'package:prepgenie/features/features.dart' as _i4;

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

/// A class which mocks [SignupUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockSignupUsecase extends _i1.Mock implements _i4.SignupUsecase {
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
  _i5.Future<_i3.Either<_i6.Failure, _i7.UserCredential>> call(
          _i4.SignupParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue:
            _i5.Future<_i3.Either<_i6.Failure, _i7.UserCredential>>.value(
                _FakeEither_1<_i6.Failure, _i7.UserCredential>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
        returnValueForMissingStub:
            _i5.Future<_i3.Either<_i6.Failure, _i7.UserCredential>>.value(
                _FakeEither_1<_i6.Failure, _i7.UserCredential>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
      ) as _i5.Future<_i3.Either<_i6.Failure, _i7.UserCredential>>);
}

/// A class which mocks [LoginUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockLoginUsecase extends _i1.Mock implements _i4.LoginUsecase {
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
  _i5.Future<_i3.Either<_i6.Failure, _i7.UserCredential>> call(
          _i4.LoginParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue:
            _i5.Future<_i3.Either<_i6.Failure, _i7.UserCredential>>.value(
                _FakeEither_1<_i6.Failure, _i7.UserCredential>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
        returnValueForMissingStub:
            _i5.Future<_i3.Either<_i6.Failure, _i7.UserCredential>>.value(
                _FakeEither_1<_i6.Failure, _i7.UserCredential>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
      ) as _i5.Future<_i3.Either<_i6.Failure, _i7.UserCredential>>);
}

/// A class which mocks [LogoutUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockLogoutUsecase extends _i1.Mock implements _i4.LogoutUsecase {
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
  _i5.Future<_i3.Either<_i6.Failure, void>> call(_i6.NoParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue: _i5.Future<_i3.Either<_i6.Failure, void>>.value(
            _FakeEither_1<_i6.Failure, void>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
        returnValueForMissingStub:
            _i5.Future<_i3.Either<_i6.Failure, void>>.value(
                _FakeEither_1<_i6.Failure, void>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
      ) as _i5.Future<_i3.Either<_i6.Failure, void>>);
}

/// A class which mocks [ForgetPasswordUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockForgetPasswordUsecase extends _i1.Mock
    implements _i4.ForgetPasswordUsecase {
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
  _i5.Future<_i3.Either<_i6.Failure, void>> call(
          _i4.ForgetPasswordParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue: _i5.Future<_i3.Either<_i6.Failure, void>>.value(
            _FakeEither_1<_i6.Failure, void>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
        returnValueForMissingStub:
            _i5.Future<_i3.Either<_i6.Failure, void>>.value(
                _FakeEither_1<_i6.Failure, void>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
      ) as _i5.Future<_i3.Either<_i6.Failure, void>>);
}

/// A class which mocks [ChangePasswordUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockChangePasswordUsecase extends _i1.Mock
    implements _i4.ChangePasswordUsecase {
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
  _i5.Future<_i3.Either<_i6.Failure, void>> call(
          _i4.ChangePasswordParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue: _i5.Future<_i3.Either<_i6.Failure, void>>.value(
            _FakeEither_1<_i6.Failure, void>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
        returnValueForMissingStub:
            _i5.Future<_i3.Either<_i6.Failure, void>>.value(
                _FakeEither_1<_i6.Failure, void>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
      ) as _i5.Future<_i3.Either<_i6.Failure, void>>);
}

/// A class which mocks [SendOtpVerificationUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockSendOtpVerificationUsecase extends _i1.Mock
    implements _i4.SendOtpVerificationUsecase {
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
  _i5.Future<_i3.Either<_i6.Failure, void>> call(
          _i4.SendOtpVerificationParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue: _i5.Future<_i3.Either<_i6.Failure, void>>.value(
            _FakeEither_1<_i6.Failure, void>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
        returnValueForMissingStub:
            _i5.Future<_i3.Either<_i6.Failure, void>>.value(
                _FakeEither_1<_i6.Failure, void>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
      ) as _i5.Future<_i3.Either<_i6.Failure, void>>);
}

/// A class which mocks [ResendOtpVerificationUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockResendOtpVerificationUsecase extends _i1.Mock
    implements _i4.ResendOtpVerificationUsecase {
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
  _i5.Future<_i3.Either<_i6.Failure, void>> call(
          _i4.ResendOtpVerificationParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue: _i5.Future<_i3.Either<_i6.Failure, void>>.value(
            _FakeEither_1<_i6.Failure, void>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
        returnValueForMissingStub:
            _i5.Future<_i3.Either<_i6.Failure, void>>.value(
                _FakeEither_1<_i6.Failure, void>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
      ) as _i5.Future<_i3.Either<_i6.Failure, void>>);
}

/// A class which mocks [InitializeAppUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockInitializeAppUsecase extends _i1.Mock
    implements _i4.InitializeAppUsecase {
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
  _i5.Future<_i3.Either<_i6.Failure, void>> call(_i6.NoParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue: _i5.Future<_i3.Either<_i6.Failure, void>>.value(
            _FakeEither_1<_i6.Failure, void>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
        returnValueForMissingStub:
            _i5.Future<_i3.Either<_i6.Failure, void>>.value(
                _FakeEither_1<_i6.Failure, void>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
      ) as _i5.Future<_i3.Either<_i6.Failure, void>>);
}

/// A class which mocks [GetAppInitializationUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetAppInitializationUsecase extends _i1.Mock
    implements _i4.GetAppInitializationUsecase {
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
  _i5.Future<_i3.Either<_i6.Failure, bool>> call(_i6.NoParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue: _i5.Future<_i3.Either<_i6.Failure, bool>>.value(
            _FakeEither_1<_i6.Failure, bool>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
        returnValueForMissingStub:
            _i5.Future<_i3.Either<_i6.Failure, bool>>.value(
                _FakeEither_1<_i6.Failure, bool>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
      ) as _i5.Future<_i3.Either<_i6.Failure, bool>>);
}

/// A class which mocks [SignInWithGoogleUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockSignInWithGoogleUsecase extends _i1.Mock
    implements _i4.SignInWithGoogleUsecase {
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
  _i5.Future<_i3.Either<_i6.Failure, _i8.User?>> call(_i6.NoParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue: _i5.Future<_i3.Either<_i6.Failure, _i8.User?>>.value(
            _FakeEither_1<_i6.Failure, _i8.User?>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
        returnValueForMissingStub:
            _i5.Future<_i3.Either<_i6.Failure, _i8.User?>>.value(
                _FakeEither_1<_i6.Failure, _i8.User?>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
      ) as _i5.Future<_i3.Either<_i6.Failure, _i8.User?>>);
}

/// A class which mocks [SignOutWithGoogleUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockSignOutWithGoogleUsecase extends _i1.Mock
    implements _i4.SignOutWithGoogleUsecase {
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
  _i5.Future<_i3.Either<_i6.Failure, void>> call(_i6.NoParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue: _i5.Future<_i3.Either<_i6.Failure, void>>.value(
            _FakeEither_1<_i6.Failure, void>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
        returnValueForMissingStub:
            _i5.Future<_i3.Either<_i6.Failure, void>>.value(
                _FakeEither_1<_i6.Failure, void>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
      ) as _i5.Future<_i3.Either<_i6.Failure, void>>);
}

/// A class which mocks [GetSignInWithGoogleUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetSignInWithGoogleUsecase extends _i1.Mock
    implements _i4.GetSignInWithGoogleUsecase {
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
  _i5.Future<_i3.Either<_i6.Failure, bool>> call(_i6.NoParams? params) =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [params],
        ),
        returnValue: _i5.Future<_i3.Either<_i6.Failure, bool>>.value(
            _FakeEither_1<_i6.Failure, bool>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
        returnValueForMissingStub:
            _i5.Future<_i3.Either<_i6.Failure, bool>>.value(
                _FakeEither_1<_i6.Failure, bool>(
          this,
          Invocation.method(
            #call,
            [params],
          ),
        )),
      ) as _i5.Future<_i3.Either<_i6.Failure, bool>>);
}
