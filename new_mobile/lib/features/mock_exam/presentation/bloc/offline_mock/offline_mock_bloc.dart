import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/core.dart';
import '../../../../features.dart';

part 'offline_mock_event.dart';
part 'offline_mock_state.dart';

class OfflineMockBloc extends Bloc<OfflineMockEvent, OfflineMockState> {
  OfflineMockBloc({
    required this.downloadMockByIdUsecase,
    required this.fetchDownloadedMocksUsecase,
    required this.isMockDownloadedUsecase,
    required this.markMockAsDownloadedUsecase,
  }) : super(OfflineMockInitial()) {
    on<DownloadMockByIdEvent>((event, emit) async {
      emit(DownloadMockByIdLoading());
      final failureOrSuccess = await downloadMockByIdUsecase(
          DownloadMockByIdParams(mockId: event.mockId));
      emit(
        failureOrSuccess.fold(
          (l) => DownloadMockByIdFailed(failure: l),
          (r) => DownloadMockByIdLoaded(),
        ),
      );
    });
    on<FetchDownloadedMockEvent>((event, emit) async {
      emit(FetchDownloadedMocksLoading());
      final failureOrSuccess = await fetchDownloadedMocksUsecase(NoParams());
      emit(
        failureOrSuccess.fold(
          (l) => FetchDownloadedMocksFailed(failure: l),
          (mocks) => FetchDownloadedMocksLoaded(mocks: mocks),
        ),
      );
    });
    on<IsMockDownloadedEvent>((event, emit) async {
      emit(IsMockDownloadedLoading());
      final failureOrSuccess = await isMockDownloadedUsecase(
          IsMockDownloadedParams(mockId: event.mockId));
      emit(
        failureOrSuccess.fold(
          (l) => IsMockDownloadedFailed(failure: l),
          (isMockDownloaded) =>
              IsMockDownloadedLoaded(isMockDownloaded: isMockDownloaded),
        ),
      );
    });
    on<MarkMockAsDownloadedEvent>((event, emit) async {
      emit(MarkMockAsDownloadedLoading());
      final failureOrSuccess = await markMockAsDownloadedUsecase(
          MarkMockAsDownloadedParams(mockId: event.mockId));
      emit(
        failureOrSuccess.fold(
          (l) => MarkMockAsDownloadedFailed(failure: l),
          (_) => MarkMockAsDownloadedLoaded(),
        ),
      );
    });
  }

  final DownloadMockByIdUsecase downloadMockByIdUsecase;
  final FetchDownloadedMocksUsecase fetchDownloadedMocksUsecase;
  final IsMockDownloadedUsecase isMockDownloadedUsecase;
  final MarkMockAsDownloadedUsecase markMockAsDownloadedUsecase;
}
