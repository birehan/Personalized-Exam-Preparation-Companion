part of 'offline_mock_user_answer_bloc.dart';

class OfflineMockUserAnswerState extends Equatable {
  const OfflineMockUserAnswerState();

  @override
  List<Object> get props => [];
}

class OfflineMockUserAnswerInitial extends OfflineMockUserAnswerState {}

class OfflineMockUserAnswerLoading extends OfflineMockUserAnswerState {}

class OfflineMockUserAnswerLoaded extends OfflineMockUserAnswerState {}

class OfflineMockUserAnswerFailed extends OfflineMockUserAnswerState {
  const OfflineMockUserAnswerFailed({
    required this.failure,
  });

  final Failure failure;

  @override
  List<Object> get props => [failure];
}
