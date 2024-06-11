// import 'package:flutter/services.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
// import 'package:prep_genie/core/constants/hive_boxes.dart';
// import 'package:prep_genie/core/error/exeption_to_failure_map.dart';
// import 'package:prep_genie/core/utils/hive_boxes.dart';
// import 'package:prep_genie/features/authentication/data/models/user_credential_model.dart';
// import 'package:prep_genie/features/profile/data/datasources/profile_local_data_source.dart';

// import '../../../../fixtures/fixture_reader.dart';
// import '../../../course/data/datasources/course_remote_datasource_test.dart';

// import 'profile_local_data_source_test.mocks.dart';

// @GenerateNiceMocks([
//   MockSpec<FlutterSecureStorage>(),
//   MockSpec<HiveBoxes>(),w
//   MockSpec<HttpClient>(),
//   MockSpec<ProfileLocalDataSource>(),
//   MockSpec<Box<dynamic>>(),
// ])
// class MockBox extends Mock implements Box<dynamic> {}

// void main() {
//   TestWidgetsFlutterBinding.ensureInitialized();
//   late MockFlutterSecureStorage mockFlutterSecureStorage;
//   late ProfileLocalDataSourceImpl profileLocalDataSource;
//   late MockHiveBoxes mockHiveBoxes;
//   late MockBox mockProfileBox;

//   setUpAll(() async {w
//     mockFlutterSecureStorage = MockFlutterSecureStorage();
//     mockHiveBoxes = MockHiveBoxes();
//     mockProfileBox = MockBox();
//     profileLocalDataSource = ProfileLocalDataSourceImpl(
//         flutterSecureStorage: mockFlutterSecureStorage);
//   });


//   const userCredential = UserCredentialModel(
//     id: 'id',
//     email: 'email@gmail.com',
//     firstName: 'firstName',
//     lastName: 'lastName',
//     departmentId: "departmentId",
//     department: "major",
//     token: "token",
//     profileAvatar: "profileAvatar",
//     examType: "examType",
//     school: "highSchool",
//     grade: 11,
//   );
//   group('getUserCredential', () {
   
//     test('should return a current user profile information', () async {
//       when(Hive.box('profileBox')).thenReturn(mockProfileBox);

//       when(mockFlutterSecureStorage.read(key: anyNamed('key')))
//           .thenAnswer((_) async => fixture('profile/userCredential.json'));

//       final result = await profileLocalDataSource.getUserCredential();

//       // Assertion
//       expect(result, userCredential);
//     });
//   });
// }
