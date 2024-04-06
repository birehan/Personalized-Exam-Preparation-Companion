import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String email;
  final String firstName;
  final String lastName;
  final String profileImage;
  final int totalScore;
  final int rank;
  final int topicsCompleted;
  final int chaptersCompleted;
  final int questionsSolved;

  const UserProfile({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profileImage,
    required this.topicsCompleted,
    required this.chaptersCompleted,
    required this.questionsSolved,
    required this.totalScore,
    required this.rank,
  });

  @override
  List<Object?> get props => [email, firstName, lastName, profileImage];
}
