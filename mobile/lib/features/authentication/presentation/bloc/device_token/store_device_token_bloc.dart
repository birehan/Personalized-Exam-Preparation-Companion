import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/core.dart';
import '../../../../features.dart';

part 'store_device_token_event.dart';
part 'store_device_token_state.dart';

class StoreDeviceTokenBloc
    extends Bloc<StoreDeviceTokenEvent, StoreDeviceTokenState> {
  StoreDeviceTokenBloc({
    required this.storeDeviceTokenUsecase,
  }) : super(StoreDeviceTokenInitial()) {
    on<StoreDeviceTokenEvent>(_storeDeviceToken);
  }

  final StoreDeviceTokenUsecase storeDeviceTokenUsecase;

  void _storeDeviceToken(
    StoreDeviceTokenEvent event,
    Emitter<StoreDeviceTokenState> emit,
  ) async {
    emit(StoreDeviceTokenLoading());
    final response = await storeDeviceTokenUsecase(NoParams());

    emit(
      response.fold(
        (l) => StoreDeviceTokenFailed(message: l.errorMessage),
        (r) => StoreDeviceTokenLoaded(),
      ),
    );
  }
}
