import 'package:equatable/equatable.dart';
import 'package:prepgenie/features/profile/domain/entities/entities.dart';


abstract class PasswordState extends Equatable {
  const PasswordState();

  @override
  List<Object> get props => [];

  get userProfile => null;
}

class Empty extends PasswordState {}

class Loaded extends PasswordState {
  final ChangePasswordEntity changePasswordEntity;

  const Loaded({required this.changePasswordEntity});
  @override
  List<Object> get props => [changePasswordEntity];
}

class Loading extends PasswordState {}

class FailedState extends PasswordState {
  final String errorMessage;

  const FailedState({required this.errorMessage});
}
