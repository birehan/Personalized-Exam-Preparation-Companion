import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/core.dart';
import '../../../../features.dart';

part 'select_department_event.dart';
part 'select_department_state.dart';

class SelectDepartmentBloc
    extends Bloc<SelectDepartmentEvent, SelectDepartmentState> {
  final GetAllGeneralDepartmentUsecase getAllGeneralDepartmentUsecase;
  SelectDepartmentBloc({required this.getAllGeneralDepartmentUsecase})
      : super(SelectDepartmentInitial()) {
    on<GetAllDepartmentsEvent>(_onGetAllDepartments);
  }
  _onGetAllDepartments(
      GetAllDepartmentsEvent event, Emitter<SelectDepartmentState> emit) async {
    emit(AllDepartmentsLoadingState());
    final eitherFailureOrDepartments =
        await getAllGeneralDepartmentUsecase(NoParams());

    emit(_eitherFailureorDepartment(eitherFailureOrDepartments));
  }

  SelectDepartmentState _eitherFailureorDepartment(
      Either<Failure, List<GeneralDepartment>> eitherFailorDepartment) {
    return eitherFailorDepartment.fold(
        (failure) => AllDepartmentsFailedState(message: failure.errorMessage),
        (departments) =>
            AllDepartmentsLoadedState(generalDepartments: departments));
  }
}
