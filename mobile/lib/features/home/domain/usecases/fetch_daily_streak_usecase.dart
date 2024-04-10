import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/core.dart';

import '../../../features.dart';

class FetchDailyStreakUsecase
    extends UseCase<DailyStreak, FetchDailyStreakParams> {
  FetchDailyStreakUsecase({
    required this.repository,
  });

  final HomeRepository repository;

  @override
  Future<Either<Failure, DailyStreak>> call(params) async {
    return await repository.fetchDailyStreak(
      params.startDate,
      params.endDate,
    );
  }
}

class FetchDailyStreakParams extends Equatable {
  final DateTime startDate;
  final DateTime endDate;

  const FetchDailyStreakParams({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}
