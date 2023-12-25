part of 'change_password_form_bloc.dart';

abstract class ChangePasswordFormEvent extends Equatable {
  const ChangePasswordFormEvent();

  @override
  List<Object> get props => [];
}

class ChangeEmailForChangePasswordForm extends ChangePasswordFormEvent {
  final String email;

  const ChangeEmailForChangePasswordForm({
    required this.email,
  });

  @override
  List<Object> get props => [email];
}

class ChangeOTPForChangePasswordForm extends ChangePasswordFormEvent {
  final String otp;

  const ChangeOTPForChangePasswordForm({
    required this.otp,
  });

  @override
  List<Object> get props => [otp];
}
