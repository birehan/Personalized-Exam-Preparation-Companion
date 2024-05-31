import '../../../features.dart';

class DownloadedUserMockModel extends DownloadedUserMock {
  const DownloadedUserMockModel({
    required super.id,
    required super.name,
    required super.departmentId,
    required super.isCompleted,
    required super.score,
    required super.questions,
    required super.subject,
    required super.examYear,
  });

  factory DownloadedUserMockModel.fromJson(Map<String, dynamic> json) {
    return DownloadedUserMockModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      departmentId:
          json['departmentId'] == null ? '' : json['departmentId']['_id'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
      score: json['score'] ?? 0,
      questions: (json['questions'] ?? [])
          .map<QuestionModel>(
            (question) => QuestionModel.fromJson(question),
          )
          .toList(),
      subject: json['subject'] ?? '',
      examYear: json['examYear'] ?? '',
      
    );
  }
}
