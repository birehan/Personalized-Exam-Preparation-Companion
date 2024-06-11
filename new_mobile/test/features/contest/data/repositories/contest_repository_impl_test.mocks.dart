// Mocks generated by Mockito 5.4.4 from annotations
// in skill_bridge_mobile/test/features/contest/data/repositories/contest_repository_impl_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:mockito/mockito.dart' as _i1;
import 'package:prep_genie/core/core.dart' as _i4;
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

class _FakeContestModel_0 extends _i1.SmartFake implements _i2.ContestModel {
  _FakeContestModel_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeContestDetail_1 extends _i1.SmartFake implements _i2.ContestDetail {
  _FakeContestDetail_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeContestRankModel_2 extends _i1.SmartFake
    implements _i2.ContestRankModel {
  _FakeContestRankModel_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [ContestRemoteDatasource].
///
/// See the documentation for Mockito's code generation for more information.
class MockContestRemoteDatasource extends _i1.Mock
    implements _i2.ContestRemoteDatasource {
  @override
  _i3.Future<List<_i2.ContestModel>> fetchPreviousContests() =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchPreviousContests,
          [],
        ),
        returnValue:
            _i3.Future<List<_i2.ContestModel>>.value(<_i2.ContestModel>[]),
        returnValueForMissingStub:
            _i3.Future<List<_i2.ContestModel>>.value(<_i2.ContestModel>[]),
      ) as _i3.Future<List<_i2.ContestModel>>);

  @override
  _i3.Future<_i2.ContestModel> fetchContestById({required String? contestId}) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchContestById,
          [],
          {#contestId: contestId},
        ),
        returnValue: _i3.Future<_i2.ContestModel>.value(_FakeContestModel_0(
          this,
          Invocation.method(
            #fetchContestById,
            [],
            {#contestId: contestId},
          ),
        )),
        returnValueForMissingStub:
            _i3.Future<_i2.ContestModel>.value(_FakeContestModel_0(
          this,
          Invocation.method(
            #fetchContestById,
            [],
            {#contestId: contestId},
          ),
        )),
      ) as _i3.Future<_i2.ContestModel>);

  @override
  _i3.Future<List<_i2.ContestModel>> fetchPreviousUserContests() =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchPreviousUserContests,
          [],
        ),
        returnValue:
            _i3.Future<List<_i2.ContestModel>>.value(<_i2.ContestModel>[]),
        returnValueForMissingStub:
            _i3.Future<List<_i2.ContestModel>>.value(<_i2.ContestModel>[]),
      ) as _i3.Future<List<_i2.ContestModel>>);

  @override
  _i3.Future<_i2.ContestModel?> fetchUpcomingUserContest() =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchUpcomingUserContest,
          [],
        ),
        returnValue: _i3.Future<_i2.ContestModel?>.value(),
        returnValueForMissingStub: _i3.Future<_i2.ContestModel?>.value(),
      ) as _i3.Future<_i2.ContestModel?>);

  @override
  _i3.Future<_i2.ContestModel> registerToContest(String? contestId) =>
      (super.noSuchMethod(
        Invocation.method(
          #registerToContest,
          [contestId],
        ),
        returnValue: _i3.Future<_i2.ContestModel>.value(_FakeContestModel_0(
          this,
          Invocation.method(
            #registerToContest,
            [contestId],
          ),
        )),
        returnValueForMissingStub:
            _i3.Future<_i2.ContestModel>.value(_FakeContestModel_0(
          this,
          Invocation.method(
            #registerToContest,
            [contestId],
          ),
        )),
      ) as _i3.Future<_i2.ContestModel>);

  @override
  _i3.Future<_i2.ContestDetail> getContestDetail(String? contestId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getContestDetail,
          [contestId],
        ),
        returnValue: _i3.Future<_i2.ContestDetail>.value(_FakeContestDetail_1(
          this,
          Invocation.method(
            #getContestDetail,
            [contestId],
          ),
        )),
        returnValueForMissingStub:
            _i3.Future<_i2.ContestDetail>.value(_FakeContestDetail_1(
          this,
          Invocation.method(
            #getContestDetail,
            [contestId],
          ),
        )),
      ) as _i3.Future<_i2.ContestDetail>);

  @override
  _i3.Future<List<_i2.ContestQuestionModel>> fetchContestQuestionByCategory(
          {required String? categoryId}) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchContestQuestionByCategory,
          [],
          {#categoryId: categoryId},
        ),
        returnValue: _i3.Future<List<_i2.ContestQuestionModel>>.value(
            <_i2.ContestQuestionModel>[]),
        returnValueForMissingStub:
            _i3.Future<List<_i2.ContestQuestionModel>>.value(
                <_i2.ContestQuestionModel>[]),
      ) as _i3.Future<List<_i2.ContestQuestionModel>>);

  @override
  _i3.Future<void> submitUserContestAnswer(
          _i2.ContestUserAnswer? contestUserAnswer) =>
      (super.noSuchMethod(
        Invocation.method(
          #submitUserContestAnswer,
          [contestUserAnswer],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<_i2.ContestRankModel> getContestRanking(String? contestId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getContestRanking,
          [contestId],
        ),
        returnValue:
            _i3.Future<_i2.ContestRankModel>.value(_FakeContestRankModel_2(
          this,
          Invocation.method(
            #getContestRanking,
            [contestId],
          ),
        )),
        returnValueForMissingStub:
            _i3.Future<_i2.ContestRankModel>.value(_FakeContestRankModel_2(
          this,
          Invocation.method(
            #getContestRanking,
            [contestId],
          ),
        )),
      ) as _i3.Future<_i2.ContestRankModel>);

  @override
  _i3.Future<List<_i2.ContestQuestionModel>> fetchContestAnalysisByCategory(
          {required String? categoryId}) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchContestAnalysisByCategory,
          [],
          {#categoryId: categoryId},
        ),
        returnValue: _i3.Future<List<_i2.ContestQuestionModel>>.value(
            <_i2.ContestQuestionModel>[]),
        returnValueForMissingStub:
            _i3.Future<List<_i2.ContestQuestionModel>>.value(
                <_i2.ContestQuestionModel>[]),
      ) as _i3.Future<List<_i2.ContestQuestionModel>>);
}

/// A class which mocks [ContestLocalDatasource].
///
/// See the documentation for Mockito's code generation for more information.
class MockContestLocalDatasource extends _i1.Mock
    implements _i2.ContestLocalDatasource {
  @override
  _i3.Future<void> cachePreviousContests(dynamic contests) =>
      (super.noSuchMethod(
        Invocation.method(
          #cachePreviousContests,
          [contests],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<List<_i2.ContestModel>?> getPreviousContests() =>
      (super.noSuchMethod(
        Invocation.method(
          #getPreviousContests,
          [],
        ),
        returnValue: _i3.Future<List<_i2.ContestModel>?>.value(),
        returnValueForMissingStub: _i3.Future<List<_i2.ContestModel>?>.value(),
      ) as _i3.Future<List<_i2.ContestModel>?>);

  @override
  _i3.Future<void> cachePreviousUserContests(dynamic contests) =>
      (super.noSuchMethod(
        Invocation.method(
          #cachePreviousUserContests,
          [contests],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<List<_i2.ContestModel>?> getPreviousUserContests() =>
      (super.noSuchMethod(
        Invocation.method(
          #getPreviousUserContests,
          [],
        ),
        returnValue: _i3.Future<List<_i2.ContestModel>?>.value(),
        returnValueForMissingStub: _i3.Future<List<_i2.ContestModel>?>.value(),
      ) as _i3.Future<List<_i2.ContestModel>?>);

  @override
  _i3.Future<void> cacheContestDetail(
    String? id,
    dynamic contestDetail,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #cacheContestDetail,
          [
            id,
            contestDetail,
          ],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<_i2.ContestDetailModel?> getContestDetail(String? id) =>
      (super.noSuchMethod(
        Invocation.method(
          #getContestDetail,
          [id],
        ),
        returnValue: _i3.Future<_i2.ContestDetailModel?>.value(),
        returnValueForMissingStub: _i3.Future<_i2.ContestDetailModel?>.value(),
      ) as _i3.Future<_i2.ContestDetailModel?>);
}

/// A class which mocks [NetworkInfo].
///
/// See the documentation for Mockito's code generation for more information.
class MockNetworkInfo extends _i1.Mock implements _i4.NetworkInfo {
  @override
  _i3.Future<bool> get isConnected => (super.noSuchMethod(
        Invocation.getter(#isConnected),
        returnValue: _i3.Future<bool>.value(false),
        returnValueForMissingStub: _i3.Future<bool>.value(false),
      ) as _i3.Future<bool>);
}
