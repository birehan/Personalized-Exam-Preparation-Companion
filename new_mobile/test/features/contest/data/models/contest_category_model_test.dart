import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:prep_genie/features/features.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const contestCategoryModel = ContestCategoryModel(
    categoryId: '659e5b96f7f62073ac67cf33',
    contestId: '659e4f5d1b78560507eadd9d',
    title: 'Biology Questions',
    subject: 'Biology',
    numberOfQuestion: 2,
    userScore: 0,
    isSubmitted: false,
  );

  test('should be a subclass of ContestCategory entity.', () async {
    // assert
    expect(contestCategoryModel, isA<ContestCategory>());
  });

  group('fromJson', () {
    test('should return a valid model when the JSON is received', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('contest/contest_category.json'));
      // act
      final result = ContestCategoryModel.fromJson(jsonMap);
      // assert
      expect(result, contestCategoryModel);
    });

    group('toJson', () {});
  });
}
