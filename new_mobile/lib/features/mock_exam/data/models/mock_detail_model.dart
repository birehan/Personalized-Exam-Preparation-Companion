import '../../../features.dart';

class MockDetailModel extends MockDetail {
  const MockDetailModel({
    required super.id,
    required super.name,
    required super.subject,
    required super.examYear,
    required super.isStandard,
    required super.numberOfQuestions,
    required super.userRank,
    required super.mockUserRanks,
  });

  factory MockDetailModel.fromJson(Map<String, dynamic> json) {
    return MockDetailModel(
      id: json['mock']['_id'],
      name: json['mock']['name'],
      subject: json['mock']['subject'],
      examYear: json['mock']['examYear'],
      isStandard: json['mock']['isStandard'],
      numberOfQuestions: (json['mock']['questions'] ?? [])
          .map((question) => question)
          .toList()
          .length,
      userRank: json['userRank'] != null
          ? MockUserRankModel.fromJson(json['userRank'])
          : null,
      mockUserRanks: (json['rankings'] ?? [])
          .map<MockUserRankModel>(
            (score) => MockUserRankModel.fromJson(score),
          )
          .toList(),
    );
  }
}
