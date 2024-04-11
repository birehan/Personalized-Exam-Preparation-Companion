import '../../../features.dart';

class MockExamModel extends MockExam {
  const MockExamModel({
    required super.id,
    required super.name,
    required super.departmentId,
    super.questions,
    super.numberOfQuestions,
    super.examYear,
  });

  factory MockExamModel.fromJson(Map<String, dynamic> json) {
    return MockExamModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      questions: (json['questions'] ?? [])
          .map<Question>((question) => QuestionModel.fromJson(question))
          .toList(),
      departmentId: json['departmentId'],
      examYear: json['examYear'],
    );
  }

  factory MockExamModel.fromDepartmentMocksJson(Map<String, dynamic> json) {
    return MockExamModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      numberOfQuestions: json['questions'] ?? 0,
      departmentId: json['departmentId'],
      examYear: json['examYear'],
    );
  }
}
