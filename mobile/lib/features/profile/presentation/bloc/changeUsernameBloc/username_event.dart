import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

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

class UserAvatarChangedEvent extends ChangeUsernameEvent {
  final File imagePath;

  UserAvatarChangedEvent({required this.imagePath});

  @override
  List<Object> get props => [imagePath];
}
