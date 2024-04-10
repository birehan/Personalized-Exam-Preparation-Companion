import 'package:equatable/equatable.dart';

import '../../../features.dart';

class HomeEntity extends Equatable {
  final HomeChapter? lastStartedChapter;
  final List<ExamDate> examDates;
  final List<HomeMock> homeMocks;

  const HomeEntity({
    required this.lastStartedChapter,
    required this.examDates,
    required this.homeMocks,
  });

  @override
  List<Object?> get props => [lastStartedChapter, examDates, homeMocks];
}
