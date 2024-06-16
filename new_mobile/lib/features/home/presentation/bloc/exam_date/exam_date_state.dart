part of 'exam_date_bloc.dart';

abstract class GetExamDateState extends Equatable {
  const GetExamDateState();

  @override
  List<Object> get props => [];
}

class GetExamDateInitial extends GetExamDateState {}

enum GetExamDateStatus { loading, loaded, error }

class ExamDateState extends GetExamDateState {
  final GetExamDateStatus status;
  final ExamDate? targetDate;
  final String? errorMessage;
  const ExamDateState({
    this.errorMessage,
    required this.status,
    this.targetDate,
  });

  @override
  List<Object> get props => [status];
}
