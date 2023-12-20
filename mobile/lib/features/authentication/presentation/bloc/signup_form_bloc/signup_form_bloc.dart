import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'signup_form_event.dart';
part 'signup_form_state.dart';

class SignupFormBloc extends Bloc<SignupFormEvent, SignupForm> {
  SignupFormBloc()
      : super(
          const SignupForm(
            emailOrPhoneNumber: '',
            firstName: '',
            lastName: '',
            password: '',
            department: '',
            major: '',
            otp: '',
          ),
        ) {
    on<ChangeEmailEvent>(_onChangeEmail);
    on<ChangePassEvent>(_onChangePassword);
    on<ChangeFirstNameEvent>(_onChangeFirstName);
    on<ChangeLastNameEvent>(_onChangeLastName);
    on<ChangeOTPEvent>(_onChangeOTP);
    on<ChangeDepartmentEvent>(_onChangeDepartment);
    on<ChangeMajorEvent>(_onChangeMajor);
  }

  void _onChangeEmail(ChangeEmailEvent event, Emitter<SignupForm> emit) async {
    emit(state.copyWith(email: event.email));
  }

  void _onChangeFirstName(
      ChangeFirstNameEvent event, Emitter<SignupFormState> emit) async {
    emit(state.copyWith(firstName: event.firstName));
  }

  void _onChangeLastName(
      ChangeLastNameEvent event, Emitter<SignupFormState> emit) async {
    emit(state.copyWith(lastName: event.lastName));
  }

  void _onChangePassword(
      ChangePassEvent event, Emitter<SignupFormState> emit) async {
    emit(state.copyWith(password: event.password));
  }

  void _onChangeOTP(ChangeOTPEvent event, Emitter<SignupFormState> emit) async {
    emit(state.copyWith(otp: event.otp));
  }

  void _onChangeDepartment(
      ChangeDepartmentEvent event, Emitter<SignupFormState> emit) async {
    emit(state.copyWith(department: event.department));
  }

  void _onChangeMajor(
      ChangeMajorEvent event, Emitter<SignupFormState> emit) async {
    emit(state.copyWith(major: event.major));
  }
}
