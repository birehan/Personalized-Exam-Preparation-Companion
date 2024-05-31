import 'package:equatable/equatable.dart';

class ContestRankEntity extends Equatable {
  final String id;
  final String contestId;
  final DateTime startsAt;
  final DateTime endsAt;
  final int score;
  final String type;
  final String userId;
  final String emailOrPhone;
  final String firstName;
  final String lastName;
  final String department;
  final String avatar;
  final int rank;

  const ContestRankEntity({
    required this.rank,
    required this.id,
    required this.contestId,
    required this.startsAt,
    required this.endsAt,
    required this.score,
    required this.type,
    required this.userId,
    required this.emailOrPhone,
    required this.firstName,
    required this.lastName,
    required this.department,
    required this.avatar,
  });

  @override
  List<Object?> get props => [
        id,
        contestId,
        startsAt,
        endsAt,
        score,
        type,
        userId,
        emailOrPhone,
        firstName,
        lastName,
        department,
        avatar
      ];
}