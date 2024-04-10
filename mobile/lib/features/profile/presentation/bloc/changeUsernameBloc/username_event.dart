import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:skill_bridge_mobile/features/profile/domain/entities/profile_update_entity.dart';

@immutable
abstract class ChangeUsernameEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class PostChangeUsername extends ChangeUsernameEvent {
  final String firstname;
  final String lastname;

  PostChangeUsername({required this.firstname, required this.lastname});

  @override
  List<Object> get props => [firstname, lastname];
}

class UpdateProfileEvent extends ChangeUsernameEvent {
  final ProfileUpdateEntity updateEntity;

  UpdateProfileEvent({required this.updateEntity});

  @override
  List<Object> get props => [updateEntity];
}
