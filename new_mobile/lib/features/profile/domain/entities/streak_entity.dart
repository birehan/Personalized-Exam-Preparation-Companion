import 'package:equatable/equatable.dart';

class StreakEntity extends Equatable {
  final int maxStreak;
  final int currentStreak;
  final int points;

  const StreakEntity({
    required this.maxStreak,
    required this.currentStreak,
    required this.points,
  });
  @override
  List<Object?> get props => [
        maxStreak,
        currentStreak,
        points,
      ];
}
