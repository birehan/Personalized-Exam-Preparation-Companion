part of 'question_vote_bloc.dart';

abstract class QuestionVoteState extends Equatable {
  const QuestionVoteState();

  @override
  List<Object> get props => [];
}

class QuestionVoteInitial extends QuestionVoteState {}

class QuestionVotedState extends QuestionVoteState {}

class QuestionVoteLoadingState extends QuestionVoteState {}

class QuestionVoteFailedState extends QuestionVoteState {
  final Failure failure;
  const QuestionVoteFailedState({required this.failure});
}
