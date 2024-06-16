import 'package:equatable/equatable.dart';

import '../../../features.dart';

class DepartmentMock extends Equatable {
  const DepartmentMock({
    required this.id,
    required this.mockExams,
  });

  final String id;
  final List<MockExam> mockExams;

  @override
  List<Object?> get props => [id, mockExams];
}
