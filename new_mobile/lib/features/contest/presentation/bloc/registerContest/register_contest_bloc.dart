import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:prep_genie/features/contest/domain/usecases/regster_to_contest.dart';

import '../../../../../core/error/failure.dart';

part 'register_contest_event.dart';
part 'register_contest_state.dart';

class RegisterContestBloc
    extends Bloc<RegisterContestEvent, RegisterContestState> {
  final ContestRegstrationUsecase contestRegstrationUsecase;
  RegisterContestBloc({required this.contestRegstrationUsecase})
      : super(RegisterContestInitial()) {
    on<RegisterUserToContestEvent>((event, emit) async {
      emit(RegisterContestInprogressState());
      final result = await contestRegstrationUsecase(
          ContestRegistrationParams(contestId: event.contestId));
      result.fold(
        (failure) => emit(RegisterContestFailedState(failure: failure)),
        (r) => emit(RegisterContestSuccessfulState()),
      );
    });
  }
}
