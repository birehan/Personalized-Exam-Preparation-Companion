part of 'question_vote_bloc.dart';

abstract class QuestionVoteEvent extends Equatable {
  const QuestionVoteEvent();

  @override
  List<Object> get props => [];
}

class QuestionVotedEvent extends QuestionVoteEvent {
  final String questionId;
  final bool isLiked;

  const QuestionVotedEvent({
    required this.questionId,
    required this.isLiked,
  });
  @override
  List<Object> get props => [
        questionId,
        isLiked,
      ];
}
