import '../../../features.dart';

class UserRankModel extends UserRank {
  const UserRankModel({
    required super.rank,
    required super.contestRankEntity,
  });

  @override
  List<Object> get props => [rank, contestRankEntity];

  factory UserRankModel.fromJson(Map<String, dynamic> json) {
    return UserRankModel(
      rank: json['rank'] ?? -1,
      contestRankEntity: ContestRankingModel.fromJson(json['userDetail']),
    );
  }
}
