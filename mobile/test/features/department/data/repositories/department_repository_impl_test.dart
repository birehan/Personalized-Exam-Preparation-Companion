import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:prepgenie/core/core.dart';
import 'package:prepgenie/core/network/network.dart';
import 'package:prepgenie/features/features.dart';

import 'department_repository_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<DepartmentRemoteDatasource>(),
  MockSpec<NetworkInfo>(),
  MockSpec<DepartmentLocalDatasource>(),
])
void main() {
  late MockDepartmentRemoteDatasource remoteDataSource;
  late MockNetworkInfo networkInfo;
  late MockDepartmentLocalDatasource localDatasource;
  late DepartmentRepositoryImpl repositoryImpl;

  setUp(() {
    remoteDataSource = MockDepartmentRemoteDatasource();
    localDatasource = MockDepartmentLocalDatasource();
    networkInfo = MockNetworkInfo();

    repositoryImpl = DepartmentRepositoryImpl(
        networkInfo: networkInfo,
        remoteDatasource: remoteDataSource,
        localDatasource: localDatasource);
  });

  const department = [
    DepartmentModel(
        description: "description",
        generalDepartmentId: "id",
        id: "id",
        name: "name",
        numberOfCourses: 5)
  ];

  const generalDepartment = [GeneralDepartmentModel(
      id: "id",
      name: "name",
      description: "description",
      departments: department,
      isForListing: false)];

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(networkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  group('getAllDepartments', () {
    test('should check if the device is online', () async {
      // arrange
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      // act
      await repositoryImpl.getAllDepartments();
      // assert
      verify(networkInfo.isConnected);
    });
    runTestsOnline(() {
      test(
          'should return list of user course when the getAllDepartments call to remote data source is successful',
          () async {
        // arrange
        when(remoteDataSource.getAllDepartments())
            .thenAnswer((_) async => generalDepartment);
        // act
        final result = await repositoryImpl.getAllDepartments();
        // assert
        verify(remoteDataSource.getAllDepartments());
        expect(result, equals(const Right(generalDepartment)));
      });
    });

    test(
        'should cache the getUserCourse when the getAllDepartments call to remote data source is successful',
        () async {
      // arrange
      when(remoteDataSource.getAllDepartments())
          .thenAnswer((_) async => generalDepartment);
      // act
      await repositoryImpl.getAllDepartments();
      // assert
      verifyNoMoreInteractions(remoteDataSource);
    });
  });

}
