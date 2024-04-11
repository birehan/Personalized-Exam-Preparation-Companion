// Mocks generated by Mockito 5.4.4 from annotations
// in skill_bridge_mobile/test/features/bookmarks/domain/repositories/bookmarks_repository_impl_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:mockito/mockito.dart' as _i1;
import 'package:skill_bridge_mobile/core/network/network.dart' as _i5;
import 'package:skill_bridge_mobile/features/bookmarks/data/data.dart' as _i3;
import 'package:skill_bridge_mobile/features/bookmarks/domain/entities/bookmarked_contents_and_questions.dart'
    as _i2;

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

class _FakeBookmarks_0 extends _i1.SmartFake implements _i2.Bookmarks {
  _FakeBookmarks_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [BookmarksRemoteDatasource].
///
/// See the documentation for Mockito's code generation for more information.
class MockBookmarksRemoteDatasource extends _i1.Mock
    implements _i3.BookmarksRemoteDatasource {
  @override
  _i4.Future<_i2.Bookmarks> getUserBookmarks() => (super.noSuchMethod(
        Invocation.method(
          #getUserBookmarks,
          [],
        ),
        returnValue: _i4.Future<_i2.Bookmarks>.value(_FakeBookmarks_0(
          this,
          Invocation.method(
            #getUserBookmarks,
            [],
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Bookmarks>.value(_FakeBookmarks_0(
          this,
          Invocation.method(
            #getUserBookmarks,
            [],
          ),
        )),
      ) as _i4.Future<_i2.Bookmarks>);

  @override
  _i4.Future<bool> bookmarkContent(String? contentId) => (super.noSuchMethod(
        Invocation.method(
          #bookmarkContent,
          [contentId],
        ),
        returnValue: _i4.Future<bool>.value(false),
        returnValueForMissingStub: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);

  @override
  _i4.Future<void> removeContentBookmark(String? contentId) =>
      (super.noSuchMethod(
        Invocation.method(
          #removeContentBookmark,
          [contentId],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> removeQuestionBookmark(String? questinoId) =>
      (super.noSuchMethod(
        Invocation.method(
          #removeQuestionBookmark,
          [questinoId],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> bookmarkQuestion(String? questionId) => (super.noSuchMethod(
        Invocation.method(
          #bookmarkQuestion,
          [questionId],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
}

/// A class which mocks [NetworkInfo].
///
/// See the documentation for Mockito's code generation for more information.
class MockNetworkInfo extends _i1.Mock implements _i5.NetworkInfo {
  @override
  _i4.Future<bool> get isConnected => (super.noSuchMethod(
        Invocation.getter(#isConnected),
        returnValue: _i4.Future<bool>.value(false),
        returnValueForMissingStub: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);
}