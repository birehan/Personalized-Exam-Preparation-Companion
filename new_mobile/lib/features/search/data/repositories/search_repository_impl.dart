import 'package:dartz/dartz.dart';
import '../../../../core/core.dart';
import '../../../features.dart';

class SearchRepositoryImpl extends SearchRepository {
  final SearchCourseRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  SearchRepositoryImpl({
    required this.networkInfo,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<Course>>> searchCourses(String query) async {
    if (await networkInfo.isConnected) {
      try {
        final courses = await remoteDataSource.searchCourses(query);
        return Right(courses);
      } catch (e) {
        return Left(await mapExceptionToFailure(e));
      }
    }

    return Left(NetworkFailure());
  }
}
