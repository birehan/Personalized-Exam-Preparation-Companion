import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/core.dart';
import '../../../../features.dart';

part 'my_mocks_event.dart';
part 'my_mocks_state.dart';

class MyMocksBloc extends Bloc<MyMocksEvent, MyMocksState> {
  final GetMyMocksUsecase getMyMocksUsecase;

  MyMocksBloc({
    required this.getMyMocksUsecase,
  }) : super(MyMocksInitial()) {
    on<GetMyMocksEvent>(_onGetMyMocks);
  }

  void _onGetMyMocks(GetMyMocksEvent event, Emitter<MyMocksState> emit) async {
    emit(const GetMyMocksState(status: MyMocksStatus.loading));
    final failureOrMocks = await getMyMocksUsecase(GetMyMocksParams(isRefreshed: event.isRefreshed),);
    emit(_mocksOrFailure(failureOrMocks));
  }

  MyMocksState _mocksOrFailure(Either<Failure, List<UserMock>> failureOrMocks) {
    return failureOrMocks.fold(
      (l) => GetMyMocksState(
        status: MyMocksStatus.error,
        errorMessage: l.errorMessage,
        failure: l,
      ),
      (userMocks) => GetMyMocksState(
        status: MyMocksStatus.loaded,
        userMocks: userMocks,
      ),
    );
  }
}
