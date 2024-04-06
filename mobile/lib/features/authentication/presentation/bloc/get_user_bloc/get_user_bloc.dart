import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/core.dart';
import '../../../../features.dart';

part 'get_user_event.dart';
part 'get_user_state.dart';

class GetUserBloc extends Bloc<GetUserEvent, GetUserState> {
  final GetUserCredentialUsecase getUserCredentialUsecase;

  GetUserBloc({
    required this.getUserCredentialUsecase,
  }) : super(GetUserInitial()) {
    on<GetUserCredentialEvent>(_onGetUserCredential);
  }

  void _onGetUserCredential(
      GetUserCredentialEvent event, Emitter<GetUserState> emit) async {
    emit(const GetUserCredentialState(status: GetUserStatus.loading));
    final failureOrGetUserCredential =
        await getUserCredentialUsecase(NoParams());
    emit(_onGetUserCredentialOrFailure(failureOrGetUserCredential));
  }

  GetUserState _onGetUserCredentialOrFailure(
      Either<Failure, UserCredential> failureOrGetUserCredential) {
    return failureOrGetUserCredential.fold(
      (l) => const GetUserCredentialState(status: GetUserStatus.error),
      (userCredential) => GetUserCredentialState(
        status: GetUserStatus.loaded,
        userCredential: userCredential,
      ),
    );
  }
}
