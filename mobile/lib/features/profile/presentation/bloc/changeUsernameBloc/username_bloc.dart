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
  final ChangeUserAvatarUsecase changeUserAvatarUsecase;
  UsernameBloc(
      {required this.changeUsernameUsecase,
      required this.changeUserAvatarUsecase})
      : super(Empty()) {
    on<ChangeUsernameEvent>(onUsernameChanged);
    on<UserAvatarChangedEvent>(onUerAvatarChanged);
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

  onUerAvatarChanged(
      UserAvatarChangedEvent event, Emitter<UsernameState> emit) async {
    emit(AvatarChangeLoading());
    final result = await changeUserAvatarUsecase(
        AvatarChangeParams(imagePath: event.imagePath));
    final UsernameState state = result.fold(
        (l) => FailedState(errorMessage: l.errorMessage),
        (r) => UserAvatartChnagedState());
    emit(state);
  }

  UsernameState _eitherLoadedOrErrorState(
    Either<Failure, ChangeUsernameEntity> failureOrData,
  ) {
    return failureOrData.fold(
        (failure) => FailedState(errorMessage: failure.errorMessage),
        (changeUsernameEntity) =>
            Loaded(changeUsernameEntity: changeUsernameEntity));
  }
}
