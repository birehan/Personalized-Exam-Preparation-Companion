part of 'mock_bloc.dart';

abstract class MockEvent extends Equatable {
  const MockEvent();

  @override
  List<Object> get props => [];
}

class GetMocksEvent extends MockEvent {
  final bool isRefreshed;

  const GetMocksEvent({
    required this.isRefreshed,
  });

  @override
  List<Object> get props => [isRefreshed];
}

class GetDepartmentMocksEvent extends MockEvent {
  final String departmentId;
  final bool isStandard;
  final bool isRefreshed;

  const GetDepartmentMocksEvent({
    required this.departmentId,
    required this.isStandard,
    required this.isRefreshed,
  });

  @override
  List<Object> get props => [departmentId, isStandard, isRefreshed];
}
