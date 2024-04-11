part of 'mock_question_bloc.dart';

abstract class MockQuestionEvent extends Equatable {
  const MockQuestionEvent();

  @override
  List<Object> get props => [];
}

class GetMockByIdEvent extends MockQuestionEvent {
  final String id;
  final int numberOfQuestions;

  const GetMockByIdEvent({required this.id, required this.numberOfQuestions});

  @override
  List<Object> get props => [id];
}

class LoadMockPageEvent extends MockQuestionEvent {
  final int pageNumber;
  final String id;

  const LoadMockPageEvent({required this.pageNumber, required this.id});
  @override
  List<Object> get props => [pageNumber];
}

class GetMockAnalysisEvent extends MockQuestionEvent {
  final String id;

  const GetMockAnalysisEvent({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}
