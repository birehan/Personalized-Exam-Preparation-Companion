import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_bridge_mobile/core/usecase/usecase.dart';
import '../../../../../core/error/failure.dart';
import 'package:skill_bridge_mobile/features/profile/domain/entities/user_profile_entity_get.dart';
import 'package:dartz/dartz.dart';
import 'package:skill_bridge_mobile/features/profile/domain/usecases/get_profile_usecase.dart';

import 'package:skill_bridge_mobile/features/profile/presentation/bloc/userProfile/userProfile_event.dart';
import 'package:skill_bridge_mobile/features/profile/presentation/bloc/userProfile/userProfile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final GetProfileUsecase getProfileUsecase;

  UserProfileBloc({
    required this.getProfileUsecase,
  }) : super(ProfileEmpty()) {
    on<UserProfileEvent>(mapEventToState);
  }

  mapEventToState(
      UserProfileEvent event, Emitter<UserProfileState> emit) async {
    if (event is GetUserProfile) {
      emit(ProfileLoading());

      final failureOrData = await getProfileUsecase(GetUserProfileParams(
          isRefreshed: event.isRefreshed, userId: event.userId));
      emit(_eitherLoadedOrErrorState(failureOrData));
    }
  }

  UserProfileState _eitherLoadedOrErrorState(
    Either<Failure, UserProfile> failureOrData,
  ) {
    return failureOrData.fold(
        (failure) => ProfileFailedState(
            errorMessage: failure.errorMessage, failure: failure),
        (userProfile) => ProfileLoaded(userProfile: userProfile));
  }
}
