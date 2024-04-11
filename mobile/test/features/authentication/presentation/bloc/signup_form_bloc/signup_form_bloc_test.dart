import 'package:flutter_test/flutter_test.dart';
import 'package:skill_bridge_mobile/features/authentication/presentation/bloc/signup_form_bloc/signup_form_bloc.dart';

void main() {
  group('SignupFormBloc', () {
    const initialState = SignupForm(
      emailOrPhoneNumber: '',
      firstName: '',
      lastName: '',
      password: '',
      otp: '',
      department: '',
      major: '',
    );

    test('emits [SignupForm] when ChangeEmailEvent is added', () {
      final bloc = SignupFormBloc();
      
      expect(bloc.state, equals(initialState));

      bloc.add(const ChangeEmailEvent(email: 'test@email.com'));

      expect(
        bloc.stream,
        emitsInOrder([initialState.copyWith(email: 'test@email.com')]),
      );
    });

    // Add tests for other events (ChangeFirstNameEvent, ChangeLastNameEvent, etc.)

    test('emits [SignupForm] with updated state when multiple events are added', () {
      final bloc = SignupFormBloc();
      
      expect(bloc.state, equals(initialState));

      bloc
        ..add(const ChangeEmailEvent(email: 'test@email.com'))
        ..add(const ChangeFirstNameEvent(firstName: 'John'))
        ..add(const ChangeLastNameEvent(lastName: 'Doe'))
        ..add(const ChangePassEvent(password: 'password'))
        ..add(const ChangeOTPEvent(otp: '123456'))
        ..add(const ChangeDepartmentEvent(department: 'Computer Science'))
        ..add(const ChangeMajorEvent(major: 'Software Engineering'));

      expect(
        bloc.stream,
        emitsInOrder([
          initialState.copyWith(email: 'test@email.com'),
          initialState.copyWith(email: 'test@email.com', firstName: 'John'),
          initialState.copyWith(email: 'test@email.com', firstName: 'John', lastName: 'Doe'),
          initialState.copyWith(email: 'test@email.com', firstName: 'John', lastName: 'Doe', password: 'password'),
          initialState.copyWith(email: 'test@email.com', firstName: 'John', lastName: 'Doe', password: 'password', otp: '123456'),
          initialState.copyWith(email: 'test@email.com', firstName: 'John', lastName: 'Doe', password: 'password', otp: '123456', department: 'Computer Science'),
          initialState.copyWith(email: 'test@email.com', firstName: 'John', lastName: 'Doe', password: 'password', otp: '123456', department: 'Computer Science', major: 'Software Engineering'),
        ]),
      );
    });
  });
}
