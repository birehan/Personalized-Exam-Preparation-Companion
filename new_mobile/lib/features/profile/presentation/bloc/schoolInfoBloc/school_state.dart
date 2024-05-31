part of 'school_bloc.dart';

class SchoolState extends Equatable {
  const SchoolState();

  @override
  List<Object> get props => [];
}

class SchoolInitial extends SchoolState {}

class SchoolLoadedState extends SchoolState {
  final SchoolDepartmentInfo schoolDepartmentInfo;

  const SchoolLoadedState({required this.schoolDepartmentInfo});
}

class SchoolLoadingState extends SchoolState {}

class SchoolFailedState extends SchoolState {}
