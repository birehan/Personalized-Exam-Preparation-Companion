import 'package:equatable/equatable.dart';
import 'package:prep_genie/core/core.dart';
import 'package:prep_genie/features/profile/domain/entities/user_profile_entity_get.dart';

abstract class UserProfileState extends Equatable {
  const UserProfileState();

  @override
  List<Object> get props => [];

  get userProfile => null;
}

class ProfileEmpty extends UserProfileState {}

class ProfileLoaded extends UserProfileState {
  final UserProfile userProfile;

  const ProfileLoaded({required this.userProfile});
  @override
  List<Object> get props => [userProfile];
}

class ProfileLoading extends UserProfileState {}

class ProfileFailedState extends UserProfileState {
  final String errorMessage;
  final Failure? failure;

  const ProfileFailedState({required this.errorMessage, this.failure});
}
