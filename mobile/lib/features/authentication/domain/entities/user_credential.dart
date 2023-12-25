// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class UserCredential extends Equatable {
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

  const UserCredential({
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
  });

  @override
  List<Object?> get props => [email, firstName, lastName];

  UserCredential copyWith({
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
