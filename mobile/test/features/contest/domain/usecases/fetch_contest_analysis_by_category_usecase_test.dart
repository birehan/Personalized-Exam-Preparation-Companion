import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prepgenie/features/features.dart';

import 'fetch_upcoming_user_contest_usecase_test.mocks.dart';

void main() {
  late MockContestRepository mockContestRepository;
  late FetchContestAnalysisByCategoryUsecase usecase;

  setUp(() {
    mockContestRepository = MockContestRepository();
    usecase = FetchContestAnalysisByCategoryUsecase(
        repository: mockContestRepository);
  });

  const contestAnalysis = [
    ContestQuestion(
      id: '659f7e41f8762555726e12f1',
      contestCategoryId: '659e5b96f7f62073ac67cf33',
      chapterId: '6530de97128c1e08e946df02',
      courseId: '6530d803128c1e08e946def8',
      subChapterId: '6530e4b2128c1e08e946df98',
      description:
          'Which type of bond links the carboxyl group of a fatty acid to the hydroxyl group of a glycerol molecule in a lipid?',
      choiceA: 'Peptide bond',
      choiceB: 'Ester bond',
      choiceC: 'Glycosidic bond',
      choiceD: 'Phosphate bond',
      relatedTopic: 'Grade 11  Enzymes Nature of enzymes',
      difficulty: 3,
      answer: 'choice_B',
      explanation:
          'Ester bonds form when the carboxyl group of a fatty acid reacts with the hydroxyl group of a glycerol molecule in a condensation reaction. This forms a triglyceride, a type of lipid. Peptide bonds are found in proteins, glycosidic bonds in carbohydrates and phosphate bonds in nucleic acids and ATP, thus these are not correct.',
      userAnswer: 'choice_E',
    ),
  ];
  test(
      'should get contestAnalysis by calling FetchContestAnalysisByCategoryUsecase',
      () async {
    // arrange
    when(mockContestRepository.fetchContestAnalysisByCategory(
            categoryId: '659e5b96f7f62073ac67cf33'))
        .thenAnswer((_) async => const Right(contestAnalysis));
    // act
    final result = await usecase(const FetchContestAnalysisByCategoryParams(
        categoryId: '659e5b96f7f62073ac67cf33'));
    // assert
    expect(result, const Right(contestAnalysis));
    verify(mockContestRepository.fetchContestAnalysisByCategory(
        categoryId: '659e5b96f7f62073ac67cf33'));
    verifyNoMoreInteractions(mockContestRepository);
  });
}
