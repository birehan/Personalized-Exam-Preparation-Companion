import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prepgenie/features/features.dart';

import 'add_mock_to_user_mocks_usecase_test.mocks.dart';

@GenerateNiceMocks([MockSpec<MockExamRepository>()])

void main(){
  late AddMockToUserMocksUsecase usecase;
  late MockMockExamRepository mockExamRepository;

   setUp(() {
    mockExamRepository = MockMockExamRepository();
    usecase = AddMockToUserMocksUsecase(mockExamRepository);
  });

  const tId = "test id";
  
  
   test(
    "Should add mock to user mocks response from repository",
    () async {
      when(mockExamRepository.addMocktoUserMocks(tId))
          .thenAnswer((_) async => const Right(unit));

      final result = await usecase.call(const AddMockToUserMocksParams(mockId: tId));

      expect(result, const Right(unit));

      verify(mockExamRepository.addMocktoUserMocks(tId));

      verifyNoMoreInteractions(mockExamRepository);
    },
  );

}