import 'package:bloc/bloc.dart';
import 'package:skill_bridge_mobile/features/profile/domain/entities/change_username_entity.dart';
import 'package:skill_bridge_mobile/features/profile/domain/usecases/change_user_avatar_usecase.dart';
import 'package:skill_bridge_mobile/features/profile/domain/usecases/change_username_usecase.dart';
import 'package:skill_bridge_mobile/features/profile/presentation/bloc/changeUsernameBloc/username_event.dart';
import 'package:skill_bridge_mobile/features/profile/presentation/bloc/changeUsernameBloc/username_state.dart';
import '../../../../../core/error/failure.dart';
import 'package:dartz/dartz.dart';

class UsernameBloc extends Bloc<ChangeUsernameEvent, UsernameState> {
  final ChangeUsernameUsecase changeUsernameUsecase;
  final UpdateUserProfileUsecase updateProfileusecase;
  UsernameBloc(
      {required this.changeUsernameUsecase, required this.updateProfileusecase})
      : super(Empty()) {
    on<ChangeUsernameEvent>(onUsernameChanged); //not used
    on<UpdateProfileEvent>(onProfileUpdate);
  }

  onUsernameChanged(
      ChangeUsernameEvent event, Emitter<UsernameState> emit) async {
    if (event is PostChangeUsername) {
      emit(Loading());

      final params =
          Params(firstname: event.firstname, lastname: event.lastname);

      final failureOrData = await changeUsernameUsecase(params);
      emit(_eitherLoadedOrErrorState(failureOrData));
    }
  }

  onProfileUpdate(UpdateProfileEvent event, Emitter<UsernameState> emit) async {
    emit(ProfileUpdateOnProgress());
    final result = await updateProfileusecase(
        ProfileUpdateParams(updateEntity: event.updateEntity));
    final UsernameState state = result.fold(
        (l) => UpdateProfileFailedState(
            errorMessage: l.errorMessage, failureType: l),
        (r) => UserProfileUpdatedState());
    emit(state);
  }

  UsernameState _eitherLoadedOrErrorState(
    Either<Failure, ChangeUsernameEntity> failureOrData,
  ) {
    return failureOrData.fold(
        (failure) => UpdateProfileFailedState(
            errorMessage: failure.errorMessage, failureType: failure),
        (changeUsernameEntity) =>
            Loaded(changeUsernameEntity: changeUsernameEntity));
  }
}
