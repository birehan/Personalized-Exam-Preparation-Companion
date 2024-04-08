import 'package:equatable/equatable.dart';

class UserDailyStreak extends Equatable {
  final DateTime date;
  final bool activeOnDay;

  const UserDailyStreak({
    required this.date,
    required this.activeOnDay,
  });

  @override
  List<Object?> get props => [date, activeOnDay];
}
