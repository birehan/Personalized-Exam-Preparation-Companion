import 'package:equatable/equatable.dart';

class UserLeaderboardRank extends Equatable {
  const UserLeaderboardRank({
    required this.id,
    required this.rank,
    required this.avatar,
    required this.firstName,
    required this.lastName,
    required this.points,
    required this.maxStreak,
    required this.contestAttended,
  });

  final String id;
  final int rank;
  final String avatar;
  final String firstName;
  final String lastName;
  final int points;
  final int maxStreak;
  final int contestAttended;

  @override
  List<Object?> get props => [
        id,
        rank,
        avatar,
        firstName,
        lastName,
        points,
        maxStreak,
        contestAttended,
      ];
}
