import 'package:dartz/dartz.dart';
import '../../../../core/core.dart';
import '../../../features.dart';



abstract class SearchRepository {
  Future<Either<Failure, List<Course>>> searchCourses(String query);
  
}
