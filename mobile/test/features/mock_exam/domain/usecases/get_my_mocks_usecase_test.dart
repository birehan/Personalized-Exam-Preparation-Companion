import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:prepgenie/features/features.dart';

import 'add_mock_to_user_mocks_usecase_test.mocks.dart';

void main(){
  late GetMyMocksUsecase usecase;
  late MockMockExamRepository mockExamRepository;

   setUp(() {
    mockExamRepository = MockMockExamRepository();
    usecase = GetMyMocksUsecase(mockExamRepository);
  });

  const tId = "test id";
  const userMocks = [UserMock(id: tId, name: "name", numberOfQuestions: 5, departmentId: tId, isCompleted: true, score: 3)];

  
  
   test(
    "Should add mock to user mocks response from repository",
    () async {
      when(mockExamRepository.getMyMocks(isRefreshed: false))
          .thenAnswer((_) async => const Right(userMocks));

      final result = await usecase.call(const GetMyMocksParams(isRefreshed: false));

      expect(result, const Right(userMocks));

      verify(mockExamRepository.getMyMocks(isRefreshed: false));

      verifyNoMoreInteractions(mockExamRepository);
    },
  );

}