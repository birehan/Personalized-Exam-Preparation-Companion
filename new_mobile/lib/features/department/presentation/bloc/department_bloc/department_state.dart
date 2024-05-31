part of 'department_bloc.dart';

abstract class DepartmentState extends Equatable {
  const DepartmentState();

  @override
  List<Object> get props => [];
}

class DepartmentInitial extends DepartmentState {}

enum GetDepartmentStatus { loading, loaded, error }

class GetDepartmentState extends DepartmentState {
  final GetDepartmentStatus status;
  final Failure? failure;
  final List<GeneralDepartment>? generalDepartments;

  const GetDepartmentState({
    required this.status,
    this.failure,
    this.generalDepartments, 
  });

  @override
  List<Object> get props => [status];
}
