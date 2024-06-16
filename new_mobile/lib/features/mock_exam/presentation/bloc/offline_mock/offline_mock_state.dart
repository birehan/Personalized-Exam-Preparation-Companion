part of 'offline_mock_bloc.dart';

class OfflineMockState extends Equatable {
  const OfflineMockState();

  @override
  List<Object> get props => [];
}

class OfflineMockInitial extends OfflineMockState {}

class DownloadMockByIdLoading extends OfflineMockState {}

class DownloadMockByIdLoaded extends OfflineMockState {}

class DownloadMockByIdFailed extends OfflineMockState {
  const DownloadMockByIdFailed({
    required this.failure,
  });

  final Failure failure;

  @override
  List<Object> get props => [failure];
}

class FetchDownloadedMocksLoading extends OfflineMockState {}

class FetchDownloadedMocksLoaded extends OfflineMockState {
  const FetchDownloadedMocksLoaded({
    required this.mocks,
  });

  final List<DownloadedUserMock> mocks;

  @override
  List<Object> get props => [mocks];
}

class FetchDownloadedMocksFailed extends OfflineMockState {
  const FetchDownloadedMocksFailed({
    required this.failure,
  });

  final Failure failure;

  @override
  List<Object> get props => [failure];
}

class IsMockDownloadedLoading extends OfflineMockState {}

class IsMockDownloadedLoaded extends OfflineMockState {
  const IsMockDownloadedLoaded({
    required this.isMockDownloaded,
  });

  final bool isMockDownloaded;

  @override
  List<Object> get props => [isMockDownloaded];
}

class IsMockDownloadedFailed extends OfflineMockState {
  const IsMockDownloadedFailed({
    required this.failure,
  });

  final Failure failure;

  @override
  List<Object> get props => [failure];
}

class MarkMockAsDownloadedLoading extends OfflineMockState {}

class MarkMockAsDownloadedLoaded extends OfflineMockState {
}

class MarkMockAsDownloadedFailed extends OfflineMockState {
  const MarkMockAsDownloadedFailed({
    required this.failure,
  });

  final Failure failure;

  @override
  List<Object> get props => [failure];
}
