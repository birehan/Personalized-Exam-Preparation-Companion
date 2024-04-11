import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:skill_bridge_mobile/core/error/failure.dart';
import 'package:skill_bridge_mobile/features/profile/domain/entities/consistency_entity.dart';
import 'package:skill_bridge_mobile/features/profile/domain/usecases/get_user_consistancy_data.dart';

part 'consistancy_bloc_event.dart';
part 'consistancy_bloc_state.dart';

class ConsistancyBlocBloc
    extends Bloc<ConsistancyBlocEvent, ConsistancyBlocState> {
  final GetUserConsistencyDataUsecase getUserConsistencyDataUsecase;
  ConsistancyBlocBloc({required this.getUserConsistencyDataUsecase})
      : super(ConsistancyBlocInitial()) {
    on<GetUserConsistencyDataEvent>((event, emit) async {
      emit(ConsistancyLoadingState());
      final allConsistencyData = await getUserConsistencyDataUsecase(
          ConsistencyParams(year: event.year, userId: event.userId));
      emit(eitherFailureOrConsistencydata(allConsistencyData));
    });
  }
  ConsistancyBlocState eitherFailureOrConsistencydata(
      Either<Failure, List<ConsistencyEntity>> response) {
    return response.fold(
      (l) => ConsistancyFailedState(failureType: l),
      (allData) {
        final consistencyData =
            List.generate(12, (index) => <ConsistencyEntity>[]);
        for (var data in allData) {
          consistencyData[data.day.month - 1].add(data);
        }
        return ConsistancyLoadedState(consistencyData: consistencyData);
      },
    );
  }
}
