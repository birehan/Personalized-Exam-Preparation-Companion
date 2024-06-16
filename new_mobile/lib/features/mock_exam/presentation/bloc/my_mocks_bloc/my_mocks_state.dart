part of 'my_mocks_bloc.dart';

abstract class MyMocksState extends Equatable {
  const MyMocksState();

  @override
  List<Object> get props => [];
}

class MyMocksInitial extends MyMocksState {}

enum MyMocksStatus { loading, loaded, error }

class GetMyMocksState extends MyMocksState {
  final MyMocksStatus status;
  final List<UserMock>? userMocks;
  final String? errorMessage;
  final Failure? failure;
  const GetMyMocksState({
    this.errorMessage,
    required this.status,
    this.userMocks,
    this.failure,
  });

  @override
  List<Object> get props => [status];
}
