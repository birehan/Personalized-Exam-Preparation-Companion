part of 'user_mock_bloc.dart';

class UserMockState extends Equatable {
  const UserMockState();

  @override
  List<Object> get props => [];
}

class UserMockInitial extends UserMockState {}

enum UserMockStatus { loading, loaded, error }

class AddMocktoUserMockState extends UserMockState {
  final UserMockStatus status;

  const AddMocktoUserMockState({
    required this.status,
  });

  @override
  List<Object> get props => [status];
}
