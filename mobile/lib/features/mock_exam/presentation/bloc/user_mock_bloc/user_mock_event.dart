part of 'user_mock_bloc.dart';

class UserMockEvent extends Equatable {
  const UserMockEvent();

  @override
  List<Object> get props => [];
}

class AddMockToUserMockEvent extends UserMockEvent {
  final String mockId;

  const AddMockToUserMockEvent({required this.mockId});

  @override
  List<Object> get props => [mockId];
}
