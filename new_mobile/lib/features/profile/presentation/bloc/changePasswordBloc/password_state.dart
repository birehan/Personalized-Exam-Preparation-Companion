import 'package:equatable/equatable.dart';
import 'package:skill_bridge_mobile/features/profile/domain/entities/entities.dart';

import '../../../../../core/error/failure.dart';

abstract class PasswordState extends Equatable {
  const PasswordState();

  @override
  List<Object> get props => [];

  get userProfile => null;
}

class Empty extends PasswordState {}

class PasswordChangedState extends PasswordState {
  final ChangePasswordEntity changePasswordEntity;

  const PasswordChangedState({required this.changePasswordEntity});
  @override
  List<Object> get props => [changePasswordEntity];
}

class PasswordChangeLoadingState extends PasswordState {}

class PasswordChangeFailedState extends PasswordState {
  final String errorMessage;
  final Failure failure;

  const PasswordChangeFailedState(
      {required this.errorMessage, required this.failure});
}
