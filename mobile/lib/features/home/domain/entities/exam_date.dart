import 'package:equatable/equatable.dart';

class ExamDate extends Equatable {
  final String id;
  final DateTime date;

  const ExamDate({
    required this.id,
    required this.date,
  });

  @override
  List<Object?> get props => [
        id,
        date,
      ];
}
