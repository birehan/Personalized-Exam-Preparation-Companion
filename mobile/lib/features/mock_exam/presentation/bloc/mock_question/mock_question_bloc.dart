import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/core.dart';
import '../../../../features.dart';

part 'mock_question_event.dart';
part 'mock_question_state.dart';

class MockQuestionBloc extends Bloc<MockQuestionEvent, MockQuestionState> {
  final GetMockExamByIdUsecase getMockExamByIdUsecase;
  MockQuestionBloc({
    required this.getMockExamByIdUsecase,
  }) : super(MockQuestionInitial()) {
    on<GetMockByIdEvent>(_onGetMockById);
    on<GetMockAnalysisEvent>(_onGetMockAnalysis);
  }

  void _onGetMockById(
      GetMockByIdEvent event, Emitter<MockQuestionState> emit) async {
    emit(const GetMockExamByIdState(status: MockQuestionStatus.loading));
    final failureOrMockQuestion = await getMockExamByIdUsecase(
      MockExamParams(id: event.id),
    );
    emit(_onMockExamByIdOrFailure(failureOrMockQuestion));
  }

  MockQuestionState _onMockExamByIdOrFailure(
      Either<Failure, Mock> failureOrMockQuestion) {
    return failureOrMockQuestion.fold(
      (l) => const GetMockExamByIdState(status: MockQuestionStatus.loading),
      (mock) => GetMockExamByIdState(
        status: MockQuestionStatus.loaded,
        mock: mock,
      ),
    );
  }

  void _onGetMockAnalysis(
      GetMockAnalysisEvent event, Emitter<MockQuestionState> emit) async {
    emit(const GetMockAnalysisState(status: MockQuestionStatus.loading));
    final failureOrMockQuestion = await getMockExamByIdUsecase(
      MockExamParams(id: event.id),
    );
    emit(_onMockAnalysisOrFailure(failureOrMockQuestion));
  }

  MockQuestionState _onMockAnalysisOrFailure(
      Either<Failure, Mock> failureOrMockQuestion) {
    return failureOrMockQuestion.fold(
      (l) => const GetMockAnalysisState(status: MockQuestionStatus.loading),
      (mock) => GetMockAnalysisState(
        status: MockQuestionStatus.loaded,
        mock: mock,
      ),
    );
  }
}
