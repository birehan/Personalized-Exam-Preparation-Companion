import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ChangePasswordEvent extends Equatable {
  @override
  List<Object> get props => [];
}


class PostChangePassword extends ChangePasswordEvent {
  final String oldPassword;
  final String newPassword;
  final String repeatPassword;

  PostChangePassword({required this.oldPassword, required this.newPassword, required this.repeatPassword});

  @override
  List<Object> get props => [oldPassword, newPassword];
}