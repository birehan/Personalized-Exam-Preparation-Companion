part of 'single_question_bloc.dart';

class SingleQuestionEvent extends Equatable {
  const SingleQuestionEvent();

  @override
  List<Object> get props => [];
}

class GetQuestionByIdEvent extends SingleQuestionEvent {
  final String questionId;

  const GetQuestionByIdEvent({required this.questionId});
}
