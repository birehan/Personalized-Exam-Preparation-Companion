import 'package:equatable/equatable.dart';

import '../../../features.dart';

class UserRank extends Equatable {
  final int rank;
  final ContestRankEntity contestRankEntity;

  const UserRank({
    required this.rank,
    required this.contestRankEntity,
  });

  @override
  List<Object?> get props => [rank, contestRankEntity];
}
