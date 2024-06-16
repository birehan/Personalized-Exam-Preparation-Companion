import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/core.dart';
import '../../../../features.dart';

part 'mock_event.dart';
part 'mock_state.dart';

class MockExamBloc extends Bloc<MockEvent, MockExamState> {
  final GetDepartmentMocksUsecase getDepartmentMocksUsecase;
  final GetMockExamsUsecase getMockExamsUsecase;

  MockExamBloc({
    required this.getDepartmentMocksUsecase,
    required this.getMockExamsUsecase,
  }) : super(MockInitial()) {
    on<GetMocksEvent>(_onGetMocks);
    on<GetDepartmentMocksEvent>(_onGetDepartmentMocks);
  }

  void _onGetMocks(GetMocksEvent event, Emitter<MockExamState> emit) async {
    emit(const GetMocksState(status: MockExamStatus.loading));
    final failureOrMockExams = await getMockExamsUsecase(
      GetMockExamsParams(isRefreshed: event.isRefreshed),
    );
    emit(_onMockExamsOrFailure(failureOrMockExams));
  }

  MockExamState _onMockExamsOrFailure(
      Either<Failure, List<MockExam>> failureOrMockExams) {
    return failureOrMockExams.fold(
      (failure) => GetMocksState(status: MockExamStatus.error, failure: failure),
      (mockExams) => GetMocksState(
        status: MockExamStatus.loaded,
        mockExams: mockExams,
      ),
    );
  }

  void _onGetDepartmentMocks(
      GetDepartmentMocksEvent event, Emitter<MockExamState> emit) async {
    emit(const GetDepartmentMocksState(status: MockExamStatus.loading));
    final failureOrMockExams = await getDepartmentMocksUsecase(
      DepartmentMocksParams(
        departmentId: event.departmentId,
        isStandard: event.isStandard,
        isRefreshed: event.isRefreshed,
      ),
    );
    emit(_onDepartmentMocksOrFailure(failureOrMockExams));
  }

  MockExamState _onDepartmentMocksOrFailure(
      Either<Failure, List<DepartmentMock>> failureOrMockExams) {
    return failureOrMockExams.fold(
      (failure) => GetDepartmentMocksState(
          status: MockExamStatus.error, failure: failure),
      (mockExams) => GetDepartmentMocksState(
        status: MockExamStatus.loaded,
        departmentMocks: mockExams,
      ),
    );
  }
}
