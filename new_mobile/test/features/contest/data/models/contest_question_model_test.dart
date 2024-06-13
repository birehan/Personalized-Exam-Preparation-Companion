import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:prep_genie/features/features.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const contestQuestionModel = ContestQuestionModel(
    id: '659f7e41f8762555726e12f1',
    courseId: '6530d803128c1e08e946def8',
    description:
        'Which type of bond links the carboxyl group of a fatty acid to the hydroxyl group of a glycerol molecule in a lipid?',
    choiceA: 'Peptide bond',
    choiceB: 'Ester bond',
    choiceC: 'Glycosidic bond',
    choiceD: 'Phosphate bond',
    chapterId: '6530de97128c1e08e946df02',
    contestCategoryId: '659e5b96f7f62073ac67cf33',
    difficulty: 3,
    relatedTopic: 'Grade 11  Enzymes Nature of enzymes',
    subChapterId: '6530e4b2128c1e08e946df98',
    answer: '',
    explanation: '',
    userAnswer: '',
  );

  const contestQuestionFromAnalysisModel = ContestQuestionModel(
    id: '659f7e41f8762555726e12f1',
    courseId: '6530d803128c1e08e946def8',
    description:
        'Which type of bond links the carboxyl group of a fatty acid to the hydroxyl group of a glycerol molecule in a lipid?',
    choiceA: 'Peptide bond',
    choiceB: 'Ester bond',
    choiceC: 'Glycosidic bond',
    choiceD: 'Phosphate bond',
    chapterId: '6530de97128c1e08e946df02',
    contestCategoryId: '659e5b96f7f62073ac67cf33',
    difficulty: 3,
    relatedTopic: 'Grade 11  Enzymes Nature of enzymes',
    subChapterId: '6530e4b2128c1e08e946df98',
    answer: 'choice_B',
    explanation:
        'Ester bonds form when the carboxyl group of a fatty acid reacts with the hydroxyl group of a glycerol molecule in a condensation reaction. This forms a triglyceride, a type of lipid. Peptide bonds are found in proteins, glycosidic bonds in carbohydrates and phosphate bonds in nucleic acids and ATP, thus these are not correct.',
    userAnswer: 'choice_E',
  );

  test('should be a subclass of ContestQuestion entity.', () async {
    // assert
    expect(contestQuestionModel, isA<ContestQuestion>());
    expect(contestQuestionFromAnalysisModel, isA<ContestQuestion>());
  });

  group('fromJson', () {
    test('should return a valid model when the JSON is received', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('contest/contest_question.json'));
      // act
      final result = ContestQuestionModel.fromJson(jsonMap);
      // assert
      expect(result, contestQuestionModel);
    });

    group('toJson', () {});
  });

  group('fromAnalysisJson', () {
    test('should return a valid model when the JSON is received', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('contest/contest_question_analysis.json'));
      // act
      final result = ContestQuestionModel.fromAnalysisJson(jsonMap);
      // assert
      expect(result, contestQuestionFromAnalysisModel);
    });

    group('toJson', () {});
  });
}
