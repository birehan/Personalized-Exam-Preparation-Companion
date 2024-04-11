import 'package:equatable/equatable.dart';
import 'package:skill_bridge_mobile/features/contest/domain/entities/contest_category.dart';
import 'package:skill_bridge_mobile/features/contest/domain/entities/contest_prize.dart';

class ContestDetail extends Equatable {
  final String contestId;
  final bool isUpcoming;
  final bool hasRegistered;
  final bool hasEnded;
  final String contestType;
  final int userScore;
  final int userRank;
  final DateTime startsAt;
  final DateTime endsAt;
  final List<ContestPrize> contestPrizes;
  final List<ContestCategory> contestCategories;
  final String description;
  final String title;
  final double timeLeft;
  final bool isLive;

  const ContestDetail({
    required this.contestId,
    required this.isUpcoming,
    required this.hasRegistered,
    required this.hasEnded,
    required this.contestType,
    required this.userScore,
    required this.startsAt,
    required this.endsAt,
    required this.contestPrizes,
    required this.contestCategories,
    required this.description,
    required this.title,
    required this.timeLeft,
    required this.userRank,
    required this.isLive,
  });
  @override
  List<Object?> get props => [
        contestId,
        isUpcoming,
        hasRegistered,
        hasEnded,
        contestType,
        userScore,
        startsAt,
        endsAt,
        contestPrizes,
        contestCategories,
        timeLeft,
        userRank,
        isLive,
      ];
}
