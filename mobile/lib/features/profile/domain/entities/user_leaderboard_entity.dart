import 'package:equatable/equatable.dart';

class UserLeaderboardEntity extends Equatable {
  final String firstName;
  final String lastName;
  final int overallRank;
  final int overallPoints;
  final String userAvatar;

  const UserLeaderboardEntity(
      {required this.firstName,
      required this.overallRank,
      required this.overallPoints,
      required this.userAvatar,
      required this.lastName});
  @override
  // TODO: implement props
  List<Object?> get props =>
      [firstName, lastName, overallPoints, overallRank, userAvatar];
}
