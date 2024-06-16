part of 'retake_mock_bloc.dart';

class RetakeMockEvent extends Equatable {
  const RetakeMockEvent({
    required this.mockId,
  });

  final String mockId;

  @override
  List<Object> get props => [mockId];
}
