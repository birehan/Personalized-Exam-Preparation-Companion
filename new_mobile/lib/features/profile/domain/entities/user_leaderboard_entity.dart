import 'package:equatable/equatable.dart';

class UserLeaderboardEntity extends Equatable {
  final String firstName;
  final String lastName;
  final int overallRank;
  final int overallPoints;
  final String userAvatar;
  final int maxStreak;
  final int contestAttended;
  final String userId;

  const UserLeaderboardEntity({
    required this.firstName,
    required this.overallRank,
    required this.overallPoints,
    required this.userAvatar,
    required this.lastName,
    required this.maxStreak,
    required this.contestAttended,
    required this.userId,
  });

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        overallPoints,
        overallRank,
        userAvatar,
        maxStreak,
        contestAttended
      ];
}
