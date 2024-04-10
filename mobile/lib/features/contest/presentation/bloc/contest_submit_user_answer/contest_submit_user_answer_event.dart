part of 'contest_submit_user_answer_bloc.dart';

class ContestSubmitUserAnswerEvent extends Equatable {
  const ContestSubmitUserAnswerEvent({
    required this.contestUserAnswer,
  });

  final ContestUserAnswer contestUserAnswer;

  @override
  List<Object> get props => [contestUserAnswer];
}
