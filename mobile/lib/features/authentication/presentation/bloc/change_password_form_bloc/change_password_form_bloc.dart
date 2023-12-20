import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'change_password_form_event.dart';
part 'change_password_form_state.dart';

class ChangePasswordFormBloc
    extends Bloc<ChangePasswordFormEvent, ChangePasswordForm> {
  ChangePasswordFormBloc()
      : super(
          const ChangePasswordForm(
            emailOrPhoneNumber: '',
            newPassword: '',
            confirmPassword: '',
            otp: '',
          ),
        ) {
    on<ChangeEmailForChangePasswordForm>(_onChangeEmail);
    on<ChangeOTPForChangePasswordForm>(_onChangeOTP);
  }

  void _onChangeEmail(ChangeEmailForChangePasswordForm event,
      Emitter<ChangePasswordFormState> emit) {
    emit(state.copyWith(emailOrPhoneNumber: event.email));
  }

  void _onChangeOTP(ChangeOTPForChangePasswordForm event,
      Emitter<ChangePasswordFormState> emit) {
    emit(state.copyWith(otp: event.otp));
  }
}
