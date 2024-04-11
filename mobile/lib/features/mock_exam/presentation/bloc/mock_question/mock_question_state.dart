part of 'mock_question_bloc.dart';

abstract class MockQuestionState extends Equatable {
  const MockQuestionState();

  @override
  List<Object> get props => [];
}

class MockQuestionInitial extends MockQuestionState {}

enum MockQuestionStatus { loading, loaded, error }

class GetMockExamByIdState extends MockQuestionState {
  const GetMockExamByIdState({
    required this.status,
    this.mock,
  });
  final MockQuestionStatus status;
  final Mock? mock;

  @override
  List<Object> get props => [status];
}

class GetMockAnalysisState extends MockQuestionState {
  final MockQuestionStatus status;
  final Mock? mock;

  const GetMockAnalysisState({
    required this.status,
    this.mock,
  });

  @override
  List<Object> get props => [status];
}
