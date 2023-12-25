// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'change_password_form_bloc.dart';

abstract class ChangePasswordFormState extends Equatable {
  const ChangePasswordFormState();

  @override
  List<Object> get props => [];
}

class ChangePasswordFormInitial extends ChangePasswordFormState {}

class ChangePasswordForm extends ChangePasswordFormState {
  final String emailOrPhoneNumber;
  final String newPassword;
  final String confirmPassword;
  final String otp;

  const ChangePasswordForm({
    required this.emailOrPhoneNumber,
    required this.newPassword,
    required this.confirmPassword,
    required this.otp,
  });

  ChangePasswordForm copyWith({
    String? emailOrPhoneNumber,
    String? newPassword,
    String? confirmPassword,
    String? otp,
  }) {
    return ChangePasswordForm(
      emailOrPhoneNumber: emailOrPhoneNumber ?? this.emailOrPhoneNumber,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      otp: otp ?? this.otp,
    );
  }

  @override
  List<Object> get props =>
      [emailOrPhoneNumber, newPassword, confirmPassword, otp];
}
