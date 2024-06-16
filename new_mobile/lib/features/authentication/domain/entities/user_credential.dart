// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class UserCredential extends Equatable {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? password;
  final String? generalDepartment;
  final String? departmentId;
  final String? department;
  final String? otp;
  final String? token;
  final String? profileAvatar;
  final String? examType;
  final String? howPrepared;
  final String? preferedMethod;
  final String? studyTimePerDay;
  final String? motivation;
  final List<String>? challangingSub;
  final String? reminder;
  final int? grade;
  final String? school;

  const UserCredential(
      {required this.id,
      required this.email,
      required this.firstName,
      required this.lastName,
      this.password,
      this.generalDepartment,
      this.departmentId,
      this.department,
      this.otp,
      this.token,
      this.profileAvatar,
      this.examType,
      this.howPrepared,
      this.preferedMethod,
      this.studyTimePerDay,
      this.motivation,
      this.challangingSub,
      this.reminder,
      this.grade,
      this.school});

  @override
  List<Object?> get props => [id, email, firstName, lastName, school, grade];

  UserCredential copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? password,
    String? generalDepartment,
    String? department,
    String? departmentId,
    String? major,
    String? otp,
    String? token,
    String? examType,
  }) {
    return UserCredential(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      password: password ?? this.password,
      generalDepartment: generalDepartment ?? this.generalDepartment,
      departmentId: departmentId ?? this.departmentId,
      department: department ?? this.department,
      otp: otp ?? this.otp,
      token: token ?? this.token,
      examType: examType ?? this.examType,
    );
  }
}
