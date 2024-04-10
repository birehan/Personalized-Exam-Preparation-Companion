part of 'retake_mock_bloc.dart';

class RetakeMockState extends Equatable {
  const RetakeMockState();

  @override
  List<Object> get props => [];
}

class RetakeMockInitial extends RetakeMockState {}

class RetakeMockLoading extends RetakeMockState {}

class RetakeMockLoaded extends RetakeMockState {}

class RetakeMockFailed extends RetakeMockState {
  final String errorMessage;

  const RetakeMockFailed({required this.errorMessage,});

  @override
  List<Object> get props => [errorMessage];
}
