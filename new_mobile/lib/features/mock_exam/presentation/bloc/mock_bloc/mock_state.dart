part of 'mock_bloc.dart';

abstract class MockExamState extends Equatable {
  const MockExamState();

  @override
  List<Object?> get props => [];
}

class MockInitial extends MockExamState {}

enum MockExamStatus { loading, loaded, error }

class GetMocksState extends MockExamState {
  final MockExamStatus status;
  final List<MockExam>? mockExams;
  final Failure? failure;

  const GetMocksState({
    required this.status,
    this.mockExams,
    this.failure,
  });

  @override
  List<Object?> get props => [status];
}

class GetDepartmentMocksState extends MockExamState {
  final MockExamStatus status;
  final List<DepartmentMock>? departmentMocks;
  final Failure? failure;

  const GetDepartmentMocksState({
    required this.status,
    this.departmentMocks,
    this.failure,
  });

  @override
  List<Object> get props => [status];
}


