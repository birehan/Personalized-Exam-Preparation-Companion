part of 'mock_question_bloc.dart';

abstract class MockQuestionEvent extends Equatable {
  const MockQuestionEvent();

  @override
  List<Object> get props => [];
}

class GetMockByIdEvent extends MockQuestionEvent {
  final String id;

  const GetMockByIdEvent({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}

class GetMockAnalysisEvent extends MockQuestionEvent {
  final String id;

  const GetMockAnalysisEvent({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}