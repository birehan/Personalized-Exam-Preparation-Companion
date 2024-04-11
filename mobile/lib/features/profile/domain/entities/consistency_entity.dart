import 'package:equatable/equatable.dart';

class ConsistencyEntity extends Equatable {
  final DateTime day;
  final int quizCompleted;
  final int chapterCompleted;
  final int subChapterCopleted;
  final int mockCompleted;
  final int questionCompleted;
  final int overallPoint;

  const ConsistencyEntity({
    required this.day,
    required this.quizCompleted,
    required this.chapterCompleted,
    required this.subChapterCopleted,
    required this.mockCompleted,
    required this.questionCompleted,
    required this.overallPoint,
  });
  @override
  List<Object?> get props => [
        day,
        quizCompleted,
        chapterCompleted,
        subChapterCopleted,
        mockCompleted,
        questionCompleted,
        overallPoint
      ];
}
