import '../../../features.dart';

class ContestRankModel extends ContestRank {
  const ContestRankModel({
    required super.contestRankEntities,
    required super.userRank,
  });

  @override
  List<Object?> get props => [contestRankEntities, userRank];

  factory ContestRankModel.fromJson(Map<String, dynamic> json) {
    return ContestRankModel(
      contestRankEntities: (json['rankings'] ?? [])
          .map<ContestRankingModel>(
            (rank) => ContestRankingModel.fromJson(rank),
          )
          .toList(),
      userRank: json['userRank'] == null
          ? null
          : UserRankModel.fromJson(json['userRank']),
    );
  }
}
