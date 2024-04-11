import 'package:flutter_test/flutter_test.dart';
import 'package:prepgenie/features/authentication/presentation/bloc/change_password_form_bloc/change_password_form_bloc.dart';

void main() {
  group('ChangePasswordFormBloc', () {
    test(
        'emits [ChangePasswordForm] when ChangeEmailForChangePasswordForm is added',
        () {
      final bloc = ChangePasswordFormBloc();
      const initialState = ChangePasswordForm(
        emailOrPhoneNumber: '',
        newPassword: '',
        confirmPassword: '',
        otp: '',
      );

      expect(bloc.state, equals(initialState));

      bloc.add(const ChangeEmailForChangePasswordForm(email: 'test@email.com'));

      expect(
        bloc.stream,
        emitsInOrder(
            [initialState.copyWith(emailOrPhoneNumber: 'test@email.com')]),
      );
    });

    test(
        'emits [ChangePasswordForm] when ChangeOTPForChangePasswordForm is added',
        () {
      final bloc = ChangePasswordFormBloc();
      const initialState = ChangePasswordForm(
        emailOrPhoneNumber: '',
        newPassword: '',
        confirmPassword: '',
        otp: '',
      );

      expect(bloc.state, equals(initialState));

      bloc.add(const ChangeOTPForChangePasswordForm(otp: '123456'));

      expect(bloc.stream, emitsInOrder([initialState.copyWith(otp: '123456')]));
    });
  });
}
