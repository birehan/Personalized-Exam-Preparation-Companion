import '../../../features.dart';

class ContestDetailModel extends ContestDetail {
  const ContestDetailModel({
    required super.contestId,
    required super.isUpcoming,
    required super.hasRegistered,
    required super.hasEnded,
    required super.contestType,
    required super.userScore,
    required super.startsAt,
    required super.endsAt,
    required super.contestPrizes,
    required super.contestCategories,
    required super.description,
    required super.title,
    required super.timeLeft,
    required super.userRank,
    required super.isLive,
  });
  factory ContestDetailModel.fromJson(Map<String, dynamic> json) {
    final contestCategories =
        json['contestCategories'] ?? <Map<String, dynamic>>[];
    final contestPrizes = json['prizeInfo'] ?? [];
    return ContestDetailModel(
      contestId: json['generalInfo']['_id'] ?? '',
      isUpcoming: json['generalInfo']['isUpcoming'],
      hasRegistered: json['generalInfo']['hasRegistered'],
      hasEnded: json['generalInfo']['hasEnded'],
      contestType: json['generalInfo']['contestType'],
      userScore: json['generalInfo']['userScore'],
      startsAt: json['generalInfo']['countDown']['startsAt'] == null
          ? DateTime.now()
          : DateTime.parse(json['generalInfo']['countDown']['startsAt']),
      endsAt: json['generalInfo']['countDown']['finishAt'] == null
          ? DateTime.now()
          : DateTime.parse(json['generalInfo']['countDown']['finishAt']),
      description: json['generalInfo']['description'],
      title: json['generalInfo']['title'],
      contestPrizes: contestPrizes
          .map<ContestPrize>((prize) => ContestPrizeModel.fromJson(prize))
          .toList(),
      contestCategories: contestCategories
          .map<ContestCategory>(
              (category) => ContestCategoryModel.fromJson(category))
          .toList(),
      timeLeft: (json['generalInfo']['timeLeft'] ?? 0).toDouble(),
      userRank: json['generalInfo']['userRank'] ?? 0,
      isLive: json['generalInfo']['isLive'] ?? false,
    );
  }
}
