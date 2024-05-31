part of 'exam_date_bloc.dart';

abstract class GetExamDateEvent extends Equatable {
  const GetExamDateEvent();

  @override
  List<Object> get props => [];
}

class ExamDateEvent extends GetExamDateEvent {}
