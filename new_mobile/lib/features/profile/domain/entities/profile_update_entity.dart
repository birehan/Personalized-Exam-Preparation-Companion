import 'dart:io';

import 'package:equatable/equatable.dart';

class ProfileUpdateEntity extends Equatable {
  final String? firstName;
  final String? lastName;
  final String? howPrepared;
  final String? preferredMethod;
  final String? studyTime;
  final String? motivation;
  final List<String>? challengingSub;
  final String? reminder;
  final String? departmentId;
  final File? imagePath;
  final int? grade;
  final String? school;
  const ProfileUpdateEntity({
    this.challengingSub,
    this.departmentId,
    this.firstName,
    this.howPrepared,
    this.lastName,
    this.motivation,
    this.preferredMethod,
    this.reminder,
    this.imagePath,
    this.studyTime,
    this.grade,
    this.school,
  });
  @override
  List<Object?> get props => [
        challengingSub,
        school,
        departmentId,
        firstName,
        grade,
        lastName,
        howPrepared,
        motivation,
        preferredMethod,
        reminder,
        studyTime,
        imagePath
      ];
}
