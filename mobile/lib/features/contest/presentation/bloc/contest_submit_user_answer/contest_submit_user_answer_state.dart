part of 'contest_submit_user_answer_bloc.dart';

class ContestSubmitUserAnswerState extends Equatable {
  const ContestSubmitUserAnswerState();

  @override
  List<Object> get props => [];
}

class ContestSubmitUserAnswerInitial extends ContestSubmitUserAnswerState {}

class ContestSubmitUserAnswerLoading extends ContestSubmitUserAnswerState {}

class ContestSubmitUserAnswerLoaded extends ContestSubmitUserAnswerState {}

class ContestSubmitUserAnswerFailed extends ContestSubmitUserAnswerState {
  const ContestSubmitUserAnswerFailed({
    required this.errorMessage,
  });

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}
