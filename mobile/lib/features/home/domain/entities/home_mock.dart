import 'package:equatable/equatable.dart';

class HomeMock extends Equatable {
  const HomeMock(
      {required this.id,
      required this.name,
      required this.departmentId,
      required this.examYear,
      required this.subject,
      required this.numberOfQuestions});

  final String id;
  final String name;
  final String departmentId;
  final String examYear;
  final String subject;
  final int numberOfQuestions;

  @override
  List<Object?> get props => [id, name, departmentId, examYear, subject];
}
