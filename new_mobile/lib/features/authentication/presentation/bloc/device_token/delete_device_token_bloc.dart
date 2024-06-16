import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/core.dart';
import '../../../../features.dart';

part 'delete_device_token_event.dart';
part 'delete_device_token_state.dart';

class DeleteDeviceTokenBloc
    extends Bloc<DeleteDeviceTokenEvent, DeleteDeviceTokenState> {
  DeleteDeviceTokenBloc({
    required this.deleteDeviceTokenUsecase,
  }) : super(DeleteDeviceTokenInitial()) {
    on<DeleteDeviceTokenEvent>(_deleteDeviceToken);
  }

  final DeleteDeviceTokenUsecase deleteDeviceTokenUsecase;

  void _deleteDeviceToken(
    DeleteDeviceTokenEvent event,
    Emitter<DeleteDeviceTokenState> emit,
  ) async {
    emit(DeleteDeviceTokenLoading());
    final response = await deleteDeviceTokenUsecase(NoParams());
    emit(
      response.fold(
        (l) => DeleteDeviceTokenFailed(message: l.errorMessage),
        (r) => DeleteDeviceTokenLoaded(),
      ),
    );
  }
}
