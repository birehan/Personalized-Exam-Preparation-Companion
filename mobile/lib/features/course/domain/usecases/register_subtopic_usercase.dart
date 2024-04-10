// import 'package:dartz/dartz.dart';
// import '../../../../core/core.dart';
// import '../../../features.dart';

// class RegisterSubtopicUsecase extends UseCase<bool, RegistrationSubtopicParams> {
//   final CourseRepositories courseRepositories;

//   RegisterSubtopicUsecase({required this.courseRepositories});
//   @override
//   Future<Either<Failure, bool>> call(RegistrationSubtopicParams params) async {
//     print('subtopic id inside register course usecase ==== $params.subtopicId');
//     return await courseRepositories.registerSubtopic(params.chapterId, params.subtopicId);
//   }
// }

// class RegistrationSubtopicParams {
//   final String chapterId;
//   final String subtopicId;

//   RegistrationSubtopicParams(this.chapterId, this.subtopicId);


// }
