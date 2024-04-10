import 'package:equatable/equatable.dart';

class TotalStreak extends Equatable {
  final num maxStreak;
  final num currentStreak;
  final num points;

  const TotalStreak({
    required this.maxStreak,
    required this.currentStreak,
    required this.points,
  });

  @override
  List<Object?> get props => [maxStreak, currentStreak, points];
}
