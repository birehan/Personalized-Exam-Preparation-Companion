part of 'mock_bloc.dart';

abstract class MockEvent extends Equatable {
  const MockEvent();

  @override
  List<Object> get props => [];
}

class GetMocksEvent extends MockEvent {}

class GetDepartmentMocksEvent extends MockEvent {
  final String departmentId;
  final bool isStandard;

  const GetDepartmentMocksEvent({
    required this.departmentId,
    required this.isStandard,
  });

  @override
  List<Object> get props => [departmentId, isStandard];
}


