import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:skill_bridge_mobile/features/features.dart';

part 'retake_mock_event.dart';
part 'retake_mock_state.dart';

class RetakeMockBloc extends Bloc<RetakeMockEvent, RetakeMockState> {
  RetakeMockBloc({
    required this.retakeMockUsecase,
  }) : super(RetakeMockInitial()) {
    on<RetakeMockEvent>(_onRetakeMock);
  }

  final RetakeMockUsecase retakeMockUsecase;

  void _onRetakeMock(
      RetakeMockEvent event, Emitter<RetakeMockState> emit) async {
    emit(RetakeMockLoading());
    final failureOrSuccess = await retakeMockUsecase(
      RetakeMockParams(mockId: event.mockId),
    );
    emit(
      failureOrSuccess.fold(
        (l) => RetakeMockFailed(errorMessage: l.errorMessage),
        (r) => RetakeMockLoaded(),
      ),
    );
  }
}
