import 'package:equatable/equatable.dart';

import '../../../features.dart';

class DownloadedUserMock extends Equatable {
  final String id;
  final String name;
  final String departmentId;
  final bool isCompleted;
  final int score;
  final List<Question> questions;
  final String subject;
  final String examYear;

  const DownloadedUserMock({
    required this.id,
    required this.name,
    required this.departmentId,
    required this.isCompleted,
    required this.score,
    required this.questions,
    required this.subject,
    required this.examYear,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        departmentId,
        isCompleted,
        score,
        questions,
        subject,
        examYear,
      ];
}
