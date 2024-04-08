import 'package:equatable/equatable.dart';
import 'package:skill_bridge_mobile/features/contest/contest.dart';

class ContestRank extends Equatable {
  final List<ContestRankEntity> contestRankEntities;
  final UserRank? userRank;

  const ContestRank({
    required this.contestRankEntities,
    required this.userRank,
  });

  @override
  List<Object?> get props => [contestRankEntities, userRank];
}
