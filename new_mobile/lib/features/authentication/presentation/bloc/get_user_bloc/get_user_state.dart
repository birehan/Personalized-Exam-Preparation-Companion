part of 'get_user_bloc.dart';

abstract class GetUserState extends Equatable {
  const GetUserState();

  @override
  List<Object> get props => [];
}

class GetUserInitial extends GetUserState {}

enum GetUserStatus { loading, loaded, error }

class GetUserCredentialState extends GetUserState {
  final GetUserStatus status;
  final UserCredential? userCredential;

  const GetUserCredentialState({
    required this.status,
    this.userCredential,
  });

  @override
  List<Object> get props => [status];
}
