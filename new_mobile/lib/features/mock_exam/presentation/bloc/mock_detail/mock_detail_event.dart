part of 'mock_detail_bloc.dart';

class MockDetailEvent extends Equatable {
  const MockDetailEvent();

  @override
  List<Object> get props => [];
}

class GetMockDetailEvent extends MockDetailEvent {
  const GetMockDetailEvent({
    required this.mockId,
  });

  final String mockId;

  @override
  List<Object> get props => [mockId];
}
