import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/core.dart';
import '../../../../features.dart';

part 'department_event.dart';
part 'department_state.dart';

class DepartmentBloc extends Bloc<DepartmentEvent, DepartmentState> {
  final GetAllGeneralDepartmentUsecase getAllGeneralDepartmentUsecase;

  DepartmentBloc({
    required this.getAllGeneralDepartmentUsecase,
  }) : super(DepartmentInitial()) {
    on<GetDepartmentEvent>(_onGetDepartment);
  }

  void _onGetDepartment(
      GetDepartmentEvent event, Emitter<DepartmentState> emit) async {
    emit(const GetDepartmentState(status: GetDepartmentStatus.loading));
    final failureOrGeneralDepartments =
        await getAllGeneralDepartmentUsecase(NoParams());
    emit(_generalDepartmentOrFailure(failureOrGeneralDepartments));
  }

  DepartmentState _generalDepartmentOrFailure(
      Either<Failure, List<GeneralDepartment>> failureOrGeneralDepartments) {
    return failureOrGeneralDepartments.fold(
      (failure) =>  GetDepartmentState(status: GetDepartmentStatus.error, failure: failure),
      (generalDepartments) => GetDepartmentState(
        status: GetDepartmentStatus.loaded,
        generalDepartments: generalDepartments,
      ),
    );
  }
}
