import 'package:equatable/equatable.dart';

import '../../../features.dart';

class Mock extends Equatable {
  final String id;
  final String name;
  final String userId;
  final List<MockQuestion> mockQuestions;

  const Mock({
    required this.id,
    required this.name,
    required this.userId,
    required this.mockQuestions,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        userId,
        mockQuestions,
      ];
}
