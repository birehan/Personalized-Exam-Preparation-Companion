import 'package:skill_bridge_mobile/core/core.dart';
import 'package:skill_bridge_mobile/features/profile/data/models/consistency_model.dart';
import 'package:skill_bridge_mobile/features/profile/domain/entities/consistency_entity.dart';

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
    required super.maxStreak,
    required super.consistecy,
    required super.points,
    required super.currentStreak,
    required super.examType,
    required super.howPrepared,
    required super.preferedMethod,
    required super.studyTimePerDay,
    required super.motivation,
    required super.reminder,
    required super.departmentId,
    required super.departmentName,
    super.grade,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      email: json['curUser']['email_phone'] ?? '',
      firstName: json['curUser']['firstName'] ?? '',
      lastName: json['curUser']['lastName'] ?? '',
      profileImage: json['curUser']['avatar'] != null
          ? json['curUser']['avatar']['imageAddress']
          : defaultProfileAvatar,
      howPrepared: json['curUser']['howPrepared'],
      motivation: json['curUser']['motivation'],
      preferedMethod: json['curUser']['preferredMethod'],
      reminder: json['curUser']['reminder'],
      studyTimePerDay: json['curUser']['studyTimePerDay'],
      departmentId: json['curUser']['department']['_id'],
      departmentName: json['curUser']['department']['name'],
      topicsCompleted: json['userStats']['topicsCompleted'] ?? 0,
      chaptersCompleted: json['userStats']['chaptersCompleted'] ?? 0,
      questionsSolved: json['userStats']['solvedQuestions'] ?? 0,
      rank: json['curUser']['rank'] ?? 0,
      totalScore: (json['curUser']['totalScore'] ?? 0).toInt(),
      maxStreak: json['totalStreak']['maxStreak'] ?? 0,
      consistecy: const [],
      currentStreak: json['totalStreak']['currentStreak'] ?? 0,
      points: (json['totalStreak']['points'] ?? 0.0).toInt(),
      examType: json['examType'] ?? '',
      grade: json['curUser']['grade'],
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
