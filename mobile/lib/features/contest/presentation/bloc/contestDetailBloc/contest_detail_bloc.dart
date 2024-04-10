import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:skill_bridge_mobile/core/error/failure.dart';
import 'package:skill_bridge_mobile/features/contest/domain/entities/contest_detail.dart';
import 'package:skill_bridge_mobile/features/contest/domain/usecases/get_contest_detail_usecase.dart';

part 'contest_detail_event.dart';
part 'contest_detail_state.dart';

class ContestDetailBloc extends Bloc<ContestDetailEvent, ContestDetailState> {
  final GetContestDetailUsecase getContestDetailUsecase;
  ContestDetailBloc({required this.getContestDetailUsecase})
      : super(ContestDetailInitial()) {
    on<GetContestdetailEvent>(_onGetContestDetail);
  }

  _onGetContestDetail(
      GetContestdetailEvent event, Emitter<ContestDetailState> emit) async {
    emit(ContestDetailLoadingState());
    final response = await getContestDetailUsecase(
        ContestDetailParams(contestId: event.contestId));

    response.fold(
      (failure) => emit(ContestDetailFailedState(failureType: failure)),
      (detail) => emit(ContestDetailLoadedState(contestDetail: detail)),
    );
  }
}
