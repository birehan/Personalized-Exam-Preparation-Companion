import 'package:equatable/equatable.dart';

import '../../../features.dart';

class MockDetail extends Equatable {
  const MockDetail({
    required this.id,
    required this.name,
    required this.subject,
    required this.examYear,
    required this.isStandard,
    required this.numberOfQuestions,
    required this.userRank,
    required this.mockUserRanks,
  });

  final String id;
  final String name;
  final String subject;
  final String examYear;
  final bool isStandard;
  final int numberOfQuestions;
  final MockUserRank? userRank;
  final List<MockUserRank> mockUserRanks;

  @override
  List<Object?> get props => [
        id,
        name,
        subject,
        examYear,
        isStandard,
        numberOfQuestions,
        userRank,
        mockUserRanks,
      ];
}
