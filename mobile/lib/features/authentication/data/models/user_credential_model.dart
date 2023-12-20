import '../../domain/domain.dart';

class UserCredentialModel extends UserCredential {
  const UserCredentialModel({
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
  });

  factory UserCredentialModel.fromJson(Map<String, dynamic> json) {
    return UserCredentialModel(
      email: json['curUser']['email_phone'] ?? '',
      firstName: json['curUser']['firstName'] ?? '',
      lastName: json['curUser']['lastName'] ?? '',
      department: json['curUser']['department'] != null
          ? json['curUser']['department']['name']
          : null,
      departmentId: json['curUser']['department'] != null
          ? json['curUser']['department']['_id']
          : null,
      // generalDepartment: json['curUser']['major'] ?? '',
      token: json['token'] ?? '',
      profileAvatar: json['curUser']['avatar'] != null
          ? json['curUser']['avatar']['imageAddress']
          : null,
      examType: json['examType'] ?? '',
    );
  }
  factory UserCredentialModel.fromUpdatedUserJson(Map<String, dynamic> json) {
    return UserCredentialModel(
      email: json['updatedUser']['email_phone'] ?? '',
      firstName: json['updatedUser']['firstName'] ?? '',
      lastName: json['updatedUser']['lastName'] ?? '',
      department: json['updatedUser']['department'] != null
          ? json['updatedUser']['department']['name']
          : null,
      departmentId: json['updatedUser']['department'] != null
          ? json['updatedUser']['department']['_id']
          : null,
      // generalDepartment: json['updatedUser']['major'] ?? '',
      profileAvatar: json['updatedUser']['avatar'] != null &&
              json['updatedUser']['avatar']['imageAddress'] != null
          ? json['updatedUser']['avatar']['imageAddress']
          : 'https://res.cloudinary.com/demo/image/upload/d_avatar.png/non_existing_id.png',
      examType: json['examType'] ?? '',
    );
  }

  factory UserCredentialModel.fromLocalCachedJson(Map<String, dynamic> json) {
    return UserCredentialModel(
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      department: json['major'] ?? '',
      departmentId: json['departmentId'] ?? '',
      // major: json['major'] ?? '',
      token: json['token'] ?? '',
      profileAvatar: json['profileAvatar'] ?? '',
      examType: json['examType'] ?? '',
    );
  }
  @override
  UserCredentialModel copyWith({
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
  }) {
    return UserCredentialModel(
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'department': generalDepartment,
      'departmentId': departmentId,
      'major': department,
      'token': token,
      'profileAvatar': profileAvatar,
      'examType': examType,
    };
  }
}
