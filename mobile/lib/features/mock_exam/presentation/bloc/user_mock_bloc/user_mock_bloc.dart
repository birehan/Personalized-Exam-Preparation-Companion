import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/core.dart';
import '../../../../features.dart';

part 'user_mock_event.dart';
part 'user_mock_state.dart';

class UserMockBloc extends Bloc<UserMockEvent, UserMockState> {
  final AddMockToUserMocksUsecase addMockToUserMocksUsecase;

  UserMockBloc({
    required this.addMockToUserMocksUsecase,
  }) : super(UserMockInitial()) {
    on<AddMockToUserMockEvent>(_onRegisterMock);
  }

  void _onRegisterMock(
      AddMockToUserMockEvent event, Emitter<UserMockState> emit) async {
    emit(const AddMocktoUserMockState(status: UserMockStatus.loading));
    final failureOrAddMock = await addMockToUserMocksUsecase(
      AddMockToUserMocksParams(mockId: event.mockId),
    );
    emit(_onAddMockToUserMockOrFailure(failureOrAddMock));
  }

  UserMockState _onAddMockToUserMockOrFailure(
      Either<Failure, void> failureOrAddMock) {
    return failureOrAddMock.fold(
      (l) => const AddMocktoUserMockState(status: UserMockStatus.error),
      (r) => const AddMocktoUserMockState(status: UserMockStatus.loaded),
    );
  }
}
