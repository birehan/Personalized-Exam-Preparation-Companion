import '../../domain/entities/user_profile_entity_get.dart';

class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.email,
    required super.firstName,
    required super.lastName,
    required super.profileImage,
    required super.topicsCompleted,
    required super.chaptersCompleted,
    required super.questionsSolved,
    required super.totalScore,
    required super.rank,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      email: json['curUser']['email_phone'] ?? '',
      firstName: json['curUser']['firstName'] ?? '',
      lastName: json['curUser']['lastName'] ?? '',
      profileImage: json['curUser']['avatar'] != null
          ? json['curUser']['avatar']['imageAddress']
          : 'https://res.cloudinary.com/demo/image/upload/d_avatar.png/non_existing_id.png',
      topicsCompleted: json['userStats']['topicsCompleted'] ?? 0,
      chaptersCompleted: json['userStats']['chaptersCompleted'] ?? 0,
      questionsSolved: json['userStats']['solvedQuestions'] ?? 0,
      rank: json['curUser']['rank'] ?? 0,
      totalScore: json['curUser']['totalScore'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'firstName': firstName,
      'profileImage': profileImage,
      'topicsCompleted': topicsCompleted,
      'chaptersCompleted': chaptersCompleted,
      'questionsSolved': questionsSolved,
    };
  }
}
