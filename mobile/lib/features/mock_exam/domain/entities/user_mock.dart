import 'package:equatable/equatable.dart';

class UserMock extends Equatable {
  final String id;
  final String name;
  final int numberOfQuestions;
  final String departmentId;
  final bool isCompleted;
  final int score;

  const UserMock({
    required this.id,
    required this.name,
    required this.numberOfQuestions,
    required this.departmentId,
    required this.isCompleted,
    required this.score,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        numberOfQuestions,
        departmentId,
        isCompleted,
        score,
      ];
}
