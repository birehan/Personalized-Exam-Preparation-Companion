import 'package:prep_genie/core/constants/app_images.dart';

import '../../domain/domain.dart';

class UserCredentialModel extends UserCredential {
  const UserCredentialModel({
    required super.id,
    required super.email,
    required super.firstName,
    required super.lastName,
    super.password,
    super.generalDepartment,
    super.departmentId,
    super.department,
    super.otp,
    super.token,
    super.profileAvatar,
    super.examType,
    super.challangingSub,
    super.grade,
    super.howPrepared,
    super.motivation,
    super.preferedMethod,
    super.reminder,
    super.school,
    super.studyTimePerDay,
  });

  factory UserCredentialModel.fromJson(Map<String, dynamic> json) {
    return UserCredentialModel(
      id: json['curUser']['_id'] ?? '',
      email: json['curUser']['email_phone'] ?? '',
      firstName: json['curUser']['firstName'] ?? '',
      lastName: json['curUser']['lastName'] ?? '',
      department: json['curUser']['department'] != null
          ? json['curUser']['department']['name']
          : null,
      departmentId: json['curUser']['department'] != null
          ? json['curUser']['department']['_id']
          : null,
      token: json['token'] ?? '',
      profileAvatar: json['curUser']['avatar'] != null
          ? json['curUser']['avatar']['imageAddress']
          : defaultProfileAvatar,
      examType: json['examType'] ?? '',
      grade: json['curUser']['grade'],
      school: json['curUser']['highSchool'],
    );
  }

  factory UserCredentialModel.fromUpdatedUserJson(Map<String, dynamic> json) {
    return UserCredentialModel(
      id: json['updatedUser']['_id'] ?? '',
      email: json['updatedUser']['email_phone'] ?? '',
      firstName: json['updatedUser']['firstName'] ?? '',
      lastName: json['updatedUser']['lastName'] ?? '',
      department: json['updatedUser']['department'] != null
          ? json['updatedUser']['department']['name']
          : null,
      departmentId: json['updatedUser']['department'] != null
          ? json['updatedUser']['department']['_id']
          : null,
      profileAvatar: json['updatedUser']['avatar'] != null &&
              json['updatedUser']['avatar']['imageAddress'] != null
          ? json['updatedUser']['avatar']['imageAddress']
          : defaultProfileAvatar,
      examType: json['examType'] ?? '',
      school: json['updatedUser']['highSchool'],
      grade: json['updatedUser']['grade'],
    );
  }

  factory UserCredentialModel.fromLocalCachedJson(Map<String, dynamic> json) {
    return UserCredentialModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      department: json['major'] ?? '',
      departmentId: json['departmentId'] ?? '',
      token: json['token'] ?? '',
      profileAvatar: json['profileAvatar'] ?? defaultProfileAvatar,
      examType: json['examType'] ?? '',
      school: json['highSchool'],
      grade: json['grade'],
    );
  }
  @override
  UserCredentialModel copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? password,
    String? generalDepartment,
    String? departmentId,
    String? department,
    String? otp,
    String? token,
    String? profileAvatar,
    String? examType,
    String? major,
    String? school,
    int? grade,
  }) {
    return UserCredentialModel(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      department: department ?? this.department,
      departmentId: departmentId ?? this.departmentId,
      examType: examType ?? this.examType,
      generalDepartment: generalDepartment ?? this.generalDepartment,
      otp: otp ?? this.otp,
      password: password ?? this.password,
      profileAvatar: profileAvatar ?? this.profileAvatar,
      token: token ?? this.token,
      grade: grade ?? this.grade,
      school: school ?? this.school,
    );
  }

  Map<String, dynamic> toJson(UserCredential uc) {
    return {
      'id': uc.id,
      'email': uc.email,
      'firstName': uc.firstName,
      'lastName': uc.lastName,
      'department': uc.generalDepartment,
      'departmentId': uc.departmentId,
      'major': uc.department,
      'token': uc.token,
      'profileAvatar': uc.profileAvatar,
      'examType': uc.examType,
      'highSchool': uc.school,
      'grade': uc.grade,
    };
  }
}
