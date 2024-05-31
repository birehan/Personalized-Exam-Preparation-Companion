import 'package:equatable/equatable.dart';

import '../../../features.dart';

class UserCourseAnalysis extends Equatable {
  final Course course;
  final List<UserChapterAnalysis> userChaptersAnalysis;

  const UserCourseAnalysis({
    required this.course,
    required this.userChaptersAnalysis,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        course,
        userChaptersAnalysis,
      ];
}
