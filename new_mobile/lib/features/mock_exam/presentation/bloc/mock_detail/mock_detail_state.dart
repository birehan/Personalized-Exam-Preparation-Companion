part of 'mock_detail_bloc.dart';

class MockDetailState extends Equatable {
  const MockDetailState();

  @override
  List<Object> get props => [];
}

class MockDetailInitial extends MockDetailState {}

class GetMockDetailLoading extends MockDetailState {}

class GetMockDetailLoaded extends MockDetailState {
  const GetMockDetailLoaded({
    required this.mockDetail,
  });

  final MockDetail mockDetail;

  @override
  List<Object> get props => [mockDetail];
}

class GetMockDetailFailed extends MockDetailState {
  const GetMockDetailFailed({
    required this.failure,
  });

  final Failure failure;

  @override
  List<Object> get props => [failure];
}
