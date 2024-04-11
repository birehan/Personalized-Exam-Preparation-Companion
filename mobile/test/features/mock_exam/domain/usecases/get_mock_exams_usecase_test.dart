import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prepgenie/features/features.dart';

import 'add_mock_to_user_mocks_usecase_test.mocks.dart';


void main(){
  late GetMockExamsUsecase usecase;
  late MockMockExamRepository mockExamRepository;

   setUp(() {
    mockExamRepository = MockMockExamRepository();
    usecase = GetMockExamsUsecase(repository: mockExamRepository);
  });

  const tId = "test id";
  const mockExams = [MockExam(id: tId, name: "name", departmentId: tId)];

  
  
   test(
    "Should add mock to user mocks response from repository",
    () async {
      when(mockExamRepository.getMocks(isRefreshed: false))
          .thenAnswer((_) async => const Right(mockExams));

      final result = await usecase.call(const GetMockExamsParams(isRefreshed: false));

      expect(result, const Right(mockExams));

      verify(mockExamRepository.getMocks(isRefreshed: false));

      verifyNoMoreInteractions(mockExamRepository);
    },
  );

}