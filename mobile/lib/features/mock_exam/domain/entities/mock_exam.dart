import 'package:equatable/equatable.dart';

import '../../../features.dart';

class MockExam extends Equatable {
  final String id;
  final String name;
  final List<Question>? questions;
  final int? numberOfQuestions;
  final String departmentId;
  final String? examYear;

  const MockExam({
    required this.id,
    required this.name,
    required this.departmentId,
    this.questions,
    this.numberOfQuestions,
    this.examYear,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        departmentId,
        questions,
        numberOfQuestions,
        examYear,
      ];
}
