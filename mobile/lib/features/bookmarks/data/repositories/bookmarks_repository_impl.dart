import 'dart:ffi';

import 'package:dartz/dartz.dart';
import 'package:skill_bridge_mobile/core/error/failure.dart';
import 'package:skill_bridge_mobile/core/network/network.dart';
import 'package:skill_bridge_mobile/features/bookmarks/data/datasources/bookmarks_remote_datasource.dart';
import 'package:skill_bridge_mobile/features/bookmarks/domain/entities/bookmarked_contents_and_questions.dart';
import 'package:skill_bridge_mobile/features/bookmarks/domain/repositories/repositories.dart';

import '../../../../core/error/exeption_to_failure_map.dart';

class BookmarksReposirotyImpl implements BookmarkRepositories {
  final BookmarksRemoteDatasource bookmarksRemoteDatasource;
  final NetworkInfo networkInfo;

  BookmarksReposirotyImpl(
      {required this.networkInfo, required this.bookmarksRemoteDatasource});
  @override
  Future<Either<Failure, bool>> bookmarkContent(String contentId) async {
    if (await networkInfo.isConnected) {
      try {
        final contentAdded =
            await bookmarksRemoteDatasource.bookmarkContent(contentId);
        return Right(contentAdded);
      } catch (e) {
        return Left(await mapExceptionToFailure(e));
      }
    }
    return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, Bookmarks>> getUserBookmarks() async {
    if (await networkInfo.isConnected) {
      try {
        Bookmarks bookmarks =
            await bookmarksRemoteDatasource.getUserBookmarks();
        return Right(bookmarks);
      } catch (e) {
        return Left(await mapExceptionToFailure(e));
      }
    }
    return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, void>> removeBookmarkedContent(
      String contentId) async {
    if (await networkInfo.isConnected) {
      try {
        await bookmarksRemoteDatasource.removeContentBookmark(contentId);
        return const Right(Void);
      } catch (e) {
        return Left(await mapExceptionToFailure(e));
      }
    }
    return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, void>> bookmarkQuestion(String qeustionId) async {
    if (await networkInfo.isConnected) {
      try {
        await bookmarksRemoteDatasource.bookmarkQuestion(qeustionId);
        return const Right(Void);
      } catch (e) {
        return Left(await mapExceptionToFailure(e));
      }
    }
    return Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, void>> removeQuestionBookmark(
      String questionId) async {
    if (await networkInfo.isConnected) {
      try {
        await bookmarksRemoteDatasource.removeQuestionBookmark(questionId);
        return const Right(Void);
      } catch (e) {
        return Left(await mapExceptionToFailure(e));
      }
    }
    return Left(NetworkFailure());
  }
}
