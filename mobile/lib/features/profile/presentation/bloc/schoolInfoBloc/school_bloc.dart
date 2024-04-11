// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:skill_bridge_mobile/core/core.dart';
// import 'package:skill_bridge_mobile/features/profile/domain/entities/school_info_enitity.dart';
// import 'package:skill_bridge_mobile/features/profile/domain/usecases/get_school_info_usecase.dart';

// part 'school_event.dart';
// part 'school_state.dart';

// class SchoolBloc extends Bloc<SchoolEvent, SchoolState> {
//   final GetSchoolInfoUsecase getSchoolInfoUsecase;
//   SchoolBloc({required this.getSchoolInfoUsecase}) : super(SchoolInitial()) {
//     on<GetSchoolInformationEvent>((event, emit) async {
//       emit(SchoolLoadingState());
//       final result = await getSchoolInfoUsecase(NoParams());
//       result.fold(
//         (l) => emit(SchoolFailedState()),
//         (sd) => emit(SchoolLoadedState(schoolDepartmentInfo: sd)),
//       );
//     });
//   }
// }


// TODO: Replace the following code with the above commented one once the backend integration finished!
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:prepgenie/core/core.dart';
import 'package:prepgenie/features/profile/domain/entities/department_entity.dart';
import 'package:prepgenie/features/profile/domain/entities/school_entity.dart';
import 'package:prepgenie/features/profile/domain/entities/school_info_enitity.dart';
import 'package:prepgenie/features/profile/domain/usecases/get_school_info_usecase.dart';

part 'school_event.dart';
part 'school_state.dart';

class SchoolBloc extends Bloc<SchoolEvent, SchoolState> {
  final GetSchoolInfoUsecase getSchoolInfoUsecase;

  SchoolBloc({required this.getSchoolInfoUsecase}) : super(SchoolInitial()) {
    on<GetSchoolInformationEvent>((event, emit) async {
      emit(SchoolLoadingState());

      // Obtain the sample school info directly
      final sampleSchoolInfo = getSampleSchoolInfo();

      // Emit the loaded state with the sample school info
      emit(SchoolLoadedState(schoolDepartmentInfo: sampleSchoolInfo));
    });
  }

  // Method to return sample school info
  SchoolDepartmentInfo getSampleSchoolInfo() {
    const schoolInfo = SchoolEntity(
      schoolId: '1',
      schoolName: 'Sample High School',
      region: 'Sample Region',
    );

    // Sample department info
    const departmentInfo = DepartmentEntity(
      departmentId: '1',
      departmentName: 'Sample Department',
    );

    // Constructing the sample school department info
    const sampleSchoolDepartmentInfo = SchoolDepartmentInfo(
      schoolInfo: [schoolInfo],
      departmentInfo: [departmentInfo],
      regionInfo: ['Sample Region'],
    );

    return sampleSchoolDepartmentInfo;
  }
}
