import 'package:equatable/equatable.dart';

class UserAnswer extends Equatable {
  final String userId;
  final String questionId;
  final String userAnswer;

  const UserAnswer(
      {required this.userId,
      required this.questionId,
      required this.userAnswer});

  @override
  // TODO: implement props
  List<Object?> get props => [userId, questionId, userAnswer];
}
