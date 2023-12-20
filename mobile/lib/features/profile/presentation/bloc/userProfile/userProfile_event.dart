import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class UserProfileEvent extends Equatable {
  @override
  List<Object> get props => [];
}


class GetUserProfile extends UserProfileEvent {}