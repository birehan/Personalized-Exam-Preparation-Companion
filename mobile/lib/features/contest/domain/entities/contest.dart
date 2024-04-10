import 'package:equatable/equatable.dart';

class Contest extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime startsAt;
  final DateTime endsAt;
  final DateTime createdAt;
  final bool? live;
  final bool? hasRegistered;
  final int timeLeft;
  final int liveRegister;
  final int virtualRegister;

  const Contest({
    required this.id,
    required this.title,
    required this.description,
    required this.startsAt,
    required this.endsAt,
    required this.createdAt,
    required this.live,
    required this.hasRegistered,
    required this.timeLeft,
    required this.liveRegister,
    required this.virtualRegister,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        startsAt,
        endsAt,
        createdAt,
        live,
        hasRegistered,
        timeLeft,
        liveRegister,
        virtualRegister,
      ];
}
