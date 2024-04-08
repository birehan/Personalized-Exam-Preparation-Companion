import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:skill_bridge_mobile/core/core.dart';
import 'package:skill_bridge_mobile/features/profile/domain/entities/school_info_enitity.dart';
import 'package:skill_bridge_mobile/features/profile/domain/usecases/get_school_info_usecase.dart';

part 'school_event.dart';
part 'school_state.dart';

class SchoolBloc extends Bloc<SchoolEvent, SchoolState> {
  final GetSchoolInfoUsecase getSchoolInfoUsecase;
  SchoolBloc({required this.getSchoolInfoUsecase}) : super(SchoolInitial()) {
    on<GetSchoolInformationEvent>((event, emit) async {
      emit(SchoolLoadingState());
      final result = await getSchoolInfoUsecase(NoParams());
      result.fold(
        (l) => emit(SchoolFailedState()),
        (sd) => emit(SchoolLoadedState(schoolDepartmentInfo: sd)),
      );
    });
  }
}
