import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/core.dart';
import '../../../../features.dart';

part 'mock_detail_event.dart';
part 'mock_detail_state.dart';

class MockDetailBloc extends Bloc<MockDetailEvent, MockDetailState> {
  MockDetailBloc({
    required this.getMockDetailUsecase,
  }) : super(MockDetailInitial()) {
    on<GetMockDetailEvent>((event, emit) async {
      emit(GetMockDetailLoading());
      final failureOrSuccess =
          await getMockDetailUsecase(GetMockDetailParams(mockId: event.mockId));
      emit(
        failureOrSuccess.fold(
          (l) => GetMockDetailFailed(failure: l),
          (mockDetail) => GetMockDetailLoaded(mockDetail: mockDetail),
        ),
      );
    });
  }

  final GetMockDetailUsecase getMockDetailUsecase;
}
