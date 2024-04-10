part of 'select_department_bloc.dart';

abstract class SelectDepartmentState extends Equatable {
  const SelectDepartmentState();

  @override
  List<Object> get props => [];
}

class SelectDepartmentInitial extends SelectDepartmentState {}

class AllDepartmentsLoadingState extends SelectDepartmentState {}

class AllDepartmentsLoadedState extends SelectDepartmentState {
  final List<GeneralDepartment> generalDepartments;

  const AllDepartmentsLoadedState({required this.generalDepartments});
  @override
  List<Object> get props => [generalDepartments];
}

class AllDepartmentsFailedState extends SelectDepartmentState {
  final String message;

  const AllDepartmentsFailedState({required this.message});
}
