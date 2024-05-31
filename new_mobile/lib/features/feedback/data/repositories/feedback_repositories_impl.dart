// ignore_for_file: void_checks

import 'dart:ffi';

import 'package:dartz/dartz.dart';
import 'package:skill_bridge_mobile/core/core.dart';

import '../../domain/entities/feedback_entity.dart';
import '../../domain/repositories/feedback_repositories.dart';
import '../datasources/feedback_remote_data_source.dart';

class FeedbackRepositoriesImpl implements FeedbackRepositories {
  final NetworkInfo networkInfo;
  final FeedbackRemoteDataSource feedbackRemoteDataSource;

  FeedbackRepositoriesImpl({
    required this.networkInfo,
    required this.feedbackRemoteDataSource,
  });
  @override
  Future<Either<Failure, void>> submitFeedback(FeedbackEntity feedback) async {
    if (await networkInfo.isConnected) {
      try {
        feedbackRemoteDataSource.submitFeedbackResponse(feedback);
        return const Right(Void);
      } catch (e) {
        return Left(await mapExceptionToFailure(e));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> voteQuestion(
      String questionId, bool isLiked) async {
    if (await networkInfo.isConnected) {
      try {
        // if allready liked call dislike endpoint
        if (isLiked) {
          feedbackRemoteDataSource.removeQuestionVote(questionId);
        } else {
          feedbackRemoteDataSource.voteQuestion(questionId);
        }
        return const Right(Void);
      } catch (e) {
        return Left(await mapExceptionToFailure(e));
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
