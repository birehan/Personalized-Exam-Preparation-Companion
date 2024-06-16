part of 'offline_mock_bloc.dart';

class OfflineMockEvent extends Equatable {
  const OfflineMockEvent();

  @override
  List<Object> get props => [];
}

class DownloadMockByIdEvent extends OfflineMockEvent {
  const DownloadMockByIdEvent({
    required this.mockId,
  });

  final String mockId;

  @override
  List<Object> get props => [mockId];
}

class FetchDownloadedMockEvent extends OfflineMockEvent {}

class IsMockDownloadedEvent extends OfflineMockEvent {
  const IsMockDownloadedEvent({
    required this.mockId,
  });

  final String mockId;

  @override
  List<Object> get props => [mockId];
}

class MarkMockAsDownloadedEvent extends OfflineMockEvent {
  const MarkMockAsDownloadedEvent({
    required this.mockId,
  });

  final String mockId;

  @override
  List<Object> get props => [mockId];
}
