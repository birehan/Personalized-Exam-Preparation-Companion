import 'package:equatable/equatable.dart';
import 'package:skill_bridge_mobile/core/error/failure.dart';
import 'package:skill_bridge_mobile/features/profile/domain/entities/entities.dart';

abstract class UsernameState extends Equatable {
  const UsernameState();

  @override
  List<Object> get props => [];

  get userProfile => null;
}

class Empty extends UsernameState {}

class Loaded extends UsernameState {
  final ChangeUsernameEntity changeUsernameEntity;

  const Loaded({required this.changeUsernameEntity});
  @override
  List<Object> get props => [changeUsernameEntity];
}

class Loading extends UsernameState {}

class ProfileUpdateOnProgress extends UsernameState {}

class UpdateProfileFailedState extends UsernameState {
  final String errorMessage;
  final Failure failureType;

  const UpdateProfileFailedState(
      {required this.errorMessage, required this.failureType});
}

class UserProfileUpdatedState extends UsernameState {}
