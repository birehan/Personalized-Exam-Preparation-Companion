import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:skill_bridge_mobile/features/features.dart';

import 'add_mock_to_user_mocks_usecase_test.mocks.dart';

void main(){
  late GetDepartmentMocksUsecase usecase;
  late MockMockExamRepository mockExamRepository;

   setUp(() {
    mockExamRepository = MockMockExamRepository();
    usecase = GetDepartmentMocksUsecase(mockExamRepository);
  });

  const tId = "test id";
  const mockExam = MockExam(id: tId, name: "name", departmentId: tId);
  const  departmentMocks = [DepartmentMock(id: tId, mockExams: [mockExam])];
  
   test(
    "Should add mock to user mocks response from repository",
    () async {
      when(mockExamRepository.getDepartmentMocks(departmentId: tId, isStandard: true, isRefreshed: false))
          .thenAnswer((_) async => const Right(departmentMocks));

      final result = await usecase.call(const DepartmentMocksParams(departmentId: tId, isStandard: true, isRefreshed: false));

      expect(result, const Right(departmentMocks));

      verify(mockExamRepository.getDepartmentMocks(departmentId: tId, isStandard: true, isRefreshed: false));

      verifyNoMoreInteractions(mockExamRepository);
    },
  );

}