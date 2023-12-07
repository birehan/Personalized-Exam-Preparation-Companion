import '../../../features.dart';

class MockModel extends Mock {
  const MockModel({
    required super.id,
    required super.name,
    required super.userId,
    required super.mockQuestions,
  });

  factory MockModel.fromJson(Map<String, dynamic> json) {
    return MockModel(
      id: json['mock']['_id'] ?? '',
      name: json['mock']['name'] ?? '',
      userId: json['mock']['userId'] ?? '',
      mockQuestions: (json['mockQuestions'] ?? [])
          .map<MockQuestion>(
            (mockQuestion) => MockQuestionModel.fromJson(mockQuestion),
          )
          .toList(),
    );
  }
}
