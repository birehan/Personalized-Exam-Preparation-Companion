import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:skill_bridge_mobile/core/core.dart';
import 'package:skill_bridge_mobile/features/profile/domain/entities/all_barchart_categories_entity.dart';
import 'package:skill_bridge_mobile/features/profile/domain/entities/score_category_for_charts_entity.dart';
import 'package:skill_bridge_mobile/features/profile/domain/usecases/load_chart_categories_usecase.dart';

part 'bar_chart_event.dart';
part 'bar_chart_state.dart';

class BarChartBloc extends Bloc<BarChartEvent, BarChartState> {
  final GetBarChartDataUseCase getBarChartDataUseCase;
  BarChartBloc({required this.getBarChartDataUseCase})
      : super(BarChartInitial()) {
    on<GetBarChartDataEvent>((event, emit) async {
      emit(BarChartDataLoadingState());
      final failureOrBarChartData = await getBarChartDataUseCase(NoParams());

      failureOrBarChartData.fold(
          (l) => emit(BarChartDataLoadFailedState(failure: l)),
          (categories) =>
              emit(BarChartDataLoadedState(categories: categories)));
    });
  }
}
