import 'package:equatable/equatable.dart';
import 'package:prepgenie/features/profile/domain/entities/consistency_entity.dart';

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
  final int maxStreak;
  final int currentStreak;
  final int points;
  final List<ConsistencyEntity> consistecy;
  final String examType;
  final String howPrepared;
  final String preferedMethod;
  final String studyTimePerDay;
  final String motivation;
  final String reminder;
  final String departmentId;
  final String departmentName;
  final int? grade;

  const UserProfile(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.profileImage,
      required this.topicsCompleted,
      required this.chaptersCompleted,
      required this.questionsSolved,
      required this.totalScore,
      required this.rank,
      required this.points,
      required this.currentStreak,
      required this.maxStreak,
      required this.consistecy,
      required this.examType,
      required this.howPrepared,
      required this.preferedMethod,
      required this.studyTimePerDay,
      required this.motivation,
      required this.reminder,
      required this.departmentId,
      this.grade,
      required this.departmentName});

  @override
  List<Object?> get props => [
        email,
        firstName,
        lastName,
        profileImage,
        topicsCompleted,
        chaptersCompleted,
        questionsSolved,
        totalScore,
        rank,
        points,
        currentStreak,
        maxStreak,
        consistecy,
        examType,
        howPrepared,
        preferedMethod,
        studyTimePerDay,
        motivation,
        reminder,
        departmentId,
        departmentName
      ];
}
