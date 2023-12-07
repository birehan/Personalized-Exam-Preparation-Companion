import 'package:dartz/dartz.dart';
import '../../../../core/core.dart';
import '../../../features.dart';

class RegisterCourseUsecase extends UseCase<bool, RegistrationParams> {
  final CourseRepositories courseRepositories;

  RegisterCourseUsecase({required this.courseRepositories});
  @override
  Future<Either<Failure, bool>> call(RegistrationParams params) async {
    print('couser id inside register course usecase ==== $params.courseId');
    return await courseRepositories.registerCourse(params.courseId);
  }
}

class RegistrationParams {
  final String courseId;

  RegistrationParams({required this.courseId});
}
