// Mocks generated by Mockito 5.4.4 from annotations
// in skill_bridge_mobile/test/features/course/domain/usecases/get_user_courses_uscase_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:dartz/dartz.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:prep_genie/core/core.dart' as _i5;
import 'package:prep_genie/features/features.dart' as _i3;

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

class _FakeEither_0<L, R> extends _i1.SmartFake implements _i2.Either<L, R> {
  _FakeEither_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [CourseRepositories].
///
/// See the documentation for Mockito's code generation for more information.
class MockCourseRepositories extends _i1.Mock
    implements _i3.CourseRepositories {
  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i3.Course>>> allCourses(
          String? departmentId) =>
      (super.noSuchMethod(
        Invocation.method(
          #allCourses,
          [departmentId],
        ),
        returnValue:
            _i4.Future<_i2.Either<_i5.Failure, List<_i3.Course>>>.value(
                _FakeEither_0<_i5.Failure, List<_i3.Course>>(
          this,
          Invocation.method(
            #allCourses,
            [departmentId],
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, List<_i3.Course>>>.value(
                _FakeEither_0<_i5.Failure, List<_i3.Course>>(
          this,
          Invocation.method(
            #allCourses,
            [departmentId],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, List<_i3.Course>>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i3.UserCourse>>> getUserCourses(
          bool? refresh) =>
      (super.noSuchMethod(
        Invocation.method(
          #getUserCourses,
          [refresh],
        ),
        returnValue:
            _i4.Future<_i2.Either<_i5.Failure, List<_i3.UserCourse>>>.value(
                _FakeEither_0<_i5.Failure, List<_i3.UserCourse>>(
          this,
          Invocation.method(
            #getUserCourses,
            [refresh],
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, List<_i3.UserCourse>>>.value(
                _FakeEither_0<_i5.Failure, List<_i3.UserCourse>>(
          this,
          Invocation.method(
            #getUserCourses,
            [refresh],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, List<_i3.UserCourse>>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i3.UserCourseAnalysis>> getCourseById({
    required String? id,
    required bool? isRefreshed,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getCourseById,
          [],
          {
            #id: id,
            #isRefreshed: isRefreshed,
          },
        ),
        returnValue:
            _i4.Future<_i2.Either<_i5.Failure, _i3.UserCourseAnalysis>>.value(
                _FakeEither_0<_i5.Failure, _i3.UserCourseAnalysis>(
          this,
          Invocation.method(
            #getCourseById,
            [],
            {
              #id: id,
              #isRefreshed: isRefreshed,
            },
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, _i3.UserCourseAnalysis>>.value(
                _FakeEither_0<_i5.Failure, _i3.UserCourseAnalysis>(
          this,
          Invocation.method(
            #getCourseById,
            [],
            {
              #id: id,
              #isRefreshed: isRefreshed,
            },
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i3.UserCourseAnalysis>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i3.Course>>>
      getCoursesByDepartmentId(String? id) => (super.noSuchMethod(
            Invocation.method(
              #getCoursesByDepartmentId,
              [id],
            ),
            returnValue:
                _i4.Future<_i2.Either<_i5.Failure, List<_i3.Course>>>.value(
                    _FakeEither_0<_i5.Failure, List<_i3.Course>>(
              this,
              Invocation.method(
                #getCoursesByDepartmentId,
                [id],
              ),
            )),
            returnValueForMissingStub:
                _i4.Future<_i2.Either<_i5.Failure, List<_i3.Course>>>.value(
                    _FakeEither_0<_i5.Failure, List<_i3.Course>>(
              this,
              Invocation.method(
                #getCoursesByDepartmentId,
                [id],
              ),
            )),
          ) as _i4.Future<_i2.Either<_i5.Failure, List<_i3.Course>>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, bool>> registerCourse(String? courseId) =>
      (super.noSuchMethod(
        Invocation.method(
          #registerCourse,
          [courseId],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, bool>>.value(
            _FakeEither_0<_i5.Failure, bool>(
          this,
          Invocation.method(
            #registerCourse,
            [courseId],
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, bool>>.value(
                _FakeEither_0<_i5.Failure, bool>(
          this,
          Invocation.method(
            #registerCourse,
            [courseId],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, bool>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, bool>> registerSubChapter(
    String? subChapter,
    String? chapterId,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #registerSubChapter,
          [
            subChapter,
            chapterId,
          ],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, bool>>.value(
            _FakeEither_0<_i5.Failure, bool>(
          this,
          Invocation.method(
            #registerSubChapter,
            [
              subChapter,
              chapterId,
            ],
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, bool>>.value(
                _FakeEither_0<_i5.Failure, bool>(
          this,
          Invocation.method(
            #registerSubChapter,
            [
              subChapter,
              chapterId,
            ],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, bool>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i3.DepartmentCourse>> getDepartmentCourse(
          String? id) =>
      (super.noSuchMethod(
        Invocation.method(
          #getDepartmentCourse,
          [id],
        ),
        returnValue:
            _i4.Future<_i2.Either<_i5.Failure, _i3.DepartmentCourse>>.value(
                _FakeEither_0<_i5.Failure, _i3.DepartmentCourse>(
          this,
          Invocation.method(
            #getDepartmentCourse,
            [id],
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, _i3.DepartmentCourse>>.value(
                _FakeEither_0<_i5.Failure, _i3.DepartmentCourse>(
          this,
          Invocation.method(
            #getDepartmentCourse,
            [id],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i3.DepartmentCourse>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i3.ChatResponse>> chat(
    bool? isContest,
    String? questionId,
    String? userQuestion,
    List<_i3.ChatHistory>? chatHistory,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #chat,
          [
            isContest,
            questionId,
            userQuestion,
            chatHistory,
          ],
        ),
        returnValue:
            _i4.Future<_i2.Either<_i5.Failure, _i3.ChatResponse>>.value(
                _FakeEither_0<_i5.Failure, _i3.ChatResponse>(
          this,
          Invocation.method(
            #chat,
            [
              isContest,
              questionId,
              userQuestion,
              chatHistory,
            ],
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, _i3.ChatResponse>>.value(
                _FakeEither_0<_i5.Failure, _i3.ChatResponse>(
          this,
          Invocation.method(
            #chat,
            [
              isContest,
              questionId,
              userQuestion,
              chatHistory,
            ],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i3.ChatResponse>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i3.ChapterVideo>>> fetchCourseVideos(
          String? courseId) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchCourseVideos,
          [courseId],
        ),
        returnValue:
            _i4.Future<_i2.Either<_i5.Failure, List<_i3.ChapterVideo>>>.value(
                _FakeEither_0<_i5.Failure, List<_i3.ChapterVideo>>(
          this,
          Invocation.method(
            #fetchCourseVideos,
            [courseId],
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, List<_i3.ChapterVideo>>>.value(
                _FakeEither_0<_i5.Failure, List<_i3.ChapterVideo>>(
          this,
          Invocation.method(
            #fetchCourseVideos,
            [courseId],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, List<_i3.ChapterVideo>>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>> downloadCourseById(
          String? courseId) =>
      (super.noSuchMethod(
        Invocation.method(
          #downloadCourseById,
          [courseId],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>.value(
            _FakeEither_0<_i5.Failure, _i2.Unit>(
          this,
          Invocation.method(
            #downloadCourseById,
            [courseId],
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>.value(
                _FakeEither_0<_i5.Failure, _i2.Unit>(
          this,
          Invocation.method(
            #downloadCourseById,
            [courseId],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i3.Course>>>
      fetchDownloadedCourses() => (super.noSuchMethod(
            Invocation.method(
              #fetchDownloadedCourses,
              [],
            ),
            returnValue:
                _i4.Future<_i2.Either<_i5.Failure, List<_i3.Course>>>.value(
                    _FakeEither_0<_i5.Failure, List<_i3.Course>>(
              this,
              Invocation.method(
                #fetchDownloadedCourses,
                [],
              ),
            )),
            returnValueForMissingStub:
                _i4.Future<_i2.Either<_i5.Failure, List<_i3.Course>>>.value(
                    _FakeEither_0<_i5.Failure, List<_i3.Course>>(
              this,
              Invocation.method(
                #fetchDownloadedCourses,
                [],
              ),
            )),
          ) as _i4.Future<_i2.Either<_i5.Failure, List<_i3.Course>>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>> markCourseAsDownloaded(
          String? courseId) =>
      (super.noSuchMethod(
        Invocation.method(
          #markCourseAsDownloaded,
          [courseId],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>.value(
            _FakeEither_0<_i5.Failure, _i2.Unit>(
          this,
          Invocation.method(
            #markCourseAsDownloaded,
            [courseId],
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>.value(
                _FakeEither_0<_i5.Failure, _i2.Unit>(
          this,
          Invocation.method(
            #markCourseAsDownloaded,
            [courseId],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i2.Unit>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, bool>> isCourseDownloaded(
          String? courseId) =>
      (super.noSuchMethod(
        Invocation.method(
          #isCourseDownloaded,
          [courseId],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, bool>>.value(
            _FakeEither_0<_i5.Failure, bool>(
          this,
          Invocation.method(
            #isCourseDownloaded,
            [courseId],
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, bool>>.value(
                _FakeEither_0<_i5.Failure, bool>(
          this,
          Invocation.method(
            #isCourseDownloaded,
            [courseId],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, bool>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, bool>> updateVideoStatus({
    required String? videoId,
    required bool? isCompleted,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateVideoStatus,
          [],
          {
            #videoId: videoId,
            #isCompleted: isCompleted,
          },
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, bool>>.value(
            _FakeEither_0<_i5.Failure, bool>(
          this,
          Invocation.method(
            #updateVideoStatus,
            [],
            {
              #videoId: videoId,
              #isCompleted: isCompleted,
            },
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Failure, bool>>.value(
                _FakeEither_0<_i5.Failure, bool>(
          this,
          Invocation.method(
            #updateVideoStatus,
            [],
            {
              #videoId: videoId,
              #isCompleted: isCompleted,
            },
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, bool>>);
}
