import 'package:intl/intl.dart';

import '../../../features.dart';

class ExamDateModel extends ExamDate {
  const ExamDateModel({
    required super.id,
    required super.date,
  });

  factory ExamDateModel.fromJson(Map<String, dynamic> json) {
    return ExamDateModel(
      id: json['_id'] ?? '',
      date: DateFormat('dd/MM/yyyy').parse(json['date'] ?? DateTime.now()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'date': date,
    };
  }
}
