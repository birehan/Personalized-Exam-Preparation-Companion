part of 'select_department_bloc.dart';

abstract class SelectDepartmentEvent extends Equatable {
  const SelectDepartmentEvent();

  @override
  List<Object> get props => [];
}

class GetAllDepartmentsEvent extends SelectDepartmentEvent {}
