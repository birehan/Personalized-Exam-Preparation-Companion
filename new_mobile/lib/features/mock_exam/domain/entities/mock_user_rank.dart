import 'package:equatable/equatable.dart';

class MockUserRank extends Equatable {
  const MockUserRank({
    required this.id,
    required this.emailOrPhone,
    required this.firstName,
    required this.lastName,
    required this.department,
    required this.avatar,
    required this.score,
    required this.rank,
  });

  final String id;
  final String emailOrPhone;
  final String firstName;
  final String lastName;
  final String department;
  final String avatar;
  final int score;
  final int rank;

  @override
  List<Object?> get props => [
        id,
        emailOrPhone,
        firstName,
        lastName,
        department,
        avatar,
        score,
        rank,
      ];
}
