import 'package:equatable/equatable.dart';

class ContestCategory extends Equatable {
  final String title;
  final String subject;
  final String contestId;
  final int numberOfQuestion;
  final String categoryId;
  final int userScore;
  final bool isSubmitted;
  const ContestCategory(
      {required this.title,
      required this.subject,
      required this.contestId,
      required this.numberOfQuestion,
      required this.categoryId,
      required this.isSubmitted,
      required this.userScore});
  @override
  List<Object?> get props => [
        title,
        subject,
        contestId,
      ];
}
