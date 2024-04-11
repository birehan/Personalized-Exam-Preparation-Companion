import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prepgenie/features/features.dart';

import 'add_mock_to_user_mocks_usecase_test.mocks.dart';

void main(){
  late RetakeMockUsecase usecase;
  late MockMockExamRepository mockExamRepository;

   setUp(() {
    mockExamRepository = MockMockExamRepository();
    usecase = RetakeMockUsecase(mockExamRepository: mockExamRepository);
  });

  const tId = "test id";
  
  
   test(
    "Should add mock to user mocks response from repository",
    () async {
      when(mockExamRepository.retakeMock(tId))
          .thenAnswer((_) async => const Right(unit));

      final result = await usecase.call(const RetakeMockParams(mockId: tId));

      expect(result, const Right(unit));

      verify(mockExamRepository.retakeMock(tId));

      verifyNoMoreInteractions(mockExamRepository);
    },
  );

}