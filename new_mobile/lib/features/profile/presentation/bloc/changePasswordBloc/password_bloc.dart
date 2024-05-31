import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:skill_bridge_mobile/features/profile/domain/entities/change_password_entity.dart';
import 'package:skill_bridge_mobile/features/profile/domain/usecases/change_password_usercase.dart';
import 'package:skill_bridge_mobile/features/profile/presentation/bloc/changePasswordBloc/password_state.dart';
import 'package:skill_bridge_mobile/features/profile/presentation/bloc/changePasswordBloc/password_event.dart';
import '../../../../../core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

class PasswordBloc extends Bloc<ChangePasswordEvent, PasswordState> {
  final ChangePasswordusecase changePasswordusecase;

  PasswordBloc({
    required this.changePasswordusecase,
  }) : super(Empty()) {
    on<PostChangePassword>(mapEventToState);
  }

  mapEventToState(
      ChangePasswordEvent event, Emitter<PasswordState> emit) async {
    if (event is PostChangePassword) {
      emit(PasswordChangeLoadingState());

      final params = Params(
          oldPassword: event.oldPassword,
          newPassword: event.newPassword,
          repeatPassword: event.repeatPassword);

      final failureOrData = await changePasswordusecase(params);
      emit(_eitherLoadedOrErrorState(failureOrData));
    }
  }

  PasswordState _eitherLoadedOrErrorState(
    Either<Failure, ChangePasswordEntity> failureOrData,
  ) {
    return failureOrData.fold(
        (failure) => PasswordChangeFailedState(
            errorMessage: failure.errorMessage, failure: failure),
        (changePasswordEntity) =>
            PasswordChangedState(changePasswordEntity: changePasswordEntity));
  }
}
