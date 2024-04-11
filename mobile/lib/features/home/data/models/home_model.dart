import 'package:prepgenie/features/features.dart';

class HomeModel extends HomeEntity {
  const HomeModel({
    required super.lastStartedChapter,
    required super.examDates,
    required super.homeMocks,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      lastStartedChapter: json['lastStartedCourse'] != null
          ? HomeChapterModel.fromJson(json['lastStartedCourse'])
          : null,
      examDates: (json['examDates'] ?? [])
          .map<ExamDateModel>((examDate) => ExamDateModel.fromJson(examDate))
          .toList(),
      homeMocks: (json['recommendedMocks'] ?? [])
          .map<HomeMockModel>((homeMock) => HomeMockModel.fromJson(homeMock))
          .toList(),
    );
  }
}
