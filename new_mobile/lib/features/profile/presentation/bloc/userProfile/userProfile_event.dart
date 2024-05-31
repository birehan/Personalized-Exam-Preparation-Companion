import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class UserProfileEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetUserProfile extends UserProfileEvent {
  final bool isRefreshed;
  final String? userId;

  GetUserProfile({required this.isRefreshed, this.userId});
}
