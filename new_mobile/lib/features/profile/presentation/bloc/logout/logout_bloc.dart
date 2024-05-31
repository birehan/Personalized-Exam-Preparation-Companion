import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/core.dart';
import '../../../domain/usecases/logout_usecase.dart';

part 'logout_event.dart';
part 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final ProfileLogoutUsecase logoutUsecase;
  LogoutBloc({required this.logoutUsecase}) : super(LogoutInitial()) {
    on<DispatchLogoutEvent>(_onDispachLogout);
  }
  _onDispachLogout(DispatchLogoutEvent event, Emitter<LogoutState> emit) async {
    emit(LoagingOutState());
    Either<Failure, bool> response = await logoutUsecase(NoParams());
    emit(_eitherFailureOrbool(response));
  }

  LogoutState _eitherFailureOrbool(Either<Failure, bool> response) {
    return response.fold(
        (failure) => LogOutFailedState(errorMessage: failure.errorMessage, failure:failure),
        (r) => LogedOutState());
  }
}
