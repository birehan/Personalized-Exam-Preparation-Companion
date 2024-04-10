import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:skill_bridge_mobile/features/course/course.dart';
import '../../../../fixtures/fixture_reader.dart';

void main() {
  const subChapterVideo = [SubchapterVideoModel(
    title: "Grade 12 Chemistry Unit 1: Arrhenius concept of acids and bases", 
    videoLink:  "https://www.youtube.com/watch?v=oIt9d9MuA74", 
    duration: "26:07", 
    id: "65e196cad8f0965397904a25", 
    courseId: "65a0f2a1938f09b54fca2b10", 
    chapterId: "65a0f6a3938f09b54fca2b17", 
    subChapterId: '', 
    order: 1, 
    thumbnailUrl: "https://i.ytimg.com/vi/oIt9d9MuA74/default.jpg")];
  const chapterVideo = ChapterVideoModel(
    courseId: "65a0f2a1938f09b54fca2b10",
    description: "NONE",
    id: "65a0f6a3938f09b54fca2b17",
    numberOfSubChapters: 5,
    order: 1,
    subchapterVideos: subChapterVideo,
    summary: "NONE",
    title: "ACID-BASE EQUILIBRIA"
  );      
       
  test('should be a subclass of course entity', () async {
    // assert
    expect(chapterVideo, isA<ChapterVideo>());
  });

  group('fromJson', () {
    test('should return a valid model when the JSON is recieved', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('chapter_video.json'));
      // act
      final result = ChapterVideoModel.fromJson(jsonMap);
      // assert
      expect(result, chapterVideo);
    });
  });
}
