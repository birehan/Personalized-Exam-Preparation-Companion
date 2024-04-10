import 'package:equatable/equatable.dart';

import 'entities.dart';

class UserCourse extends Equatable {
  final String id;
  final String userId;
  final Course course;
  final int completedChapters;

  const UserCourse({
    required this.id,
    required this.userId,
    required this.course,
    required this.completedChapters,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        course,
        completedChapters,
      ];
}
