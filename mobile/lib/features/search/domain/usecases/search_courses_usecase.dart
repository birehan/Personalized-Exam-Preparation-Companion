import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/core.dart';
import '../../../features.dart';



class SearchCoursesUsecase extends UseCase<List<Course>, SearchCourseQueryParams> {
  final SearchRepository searchRepository;

  SearchCoursesUsecase(
    this.searchRepository,
  );

  @override
  Future<Either<Failure, List<Course>>> call(SearchCourseQueryParams params) async {
    return await searchRepository.searchCourses(params.query);
  }
}



class SearchCourseQueryParams extends Equatable {
  final String query;

  const SearchCourseQueryParams({required this.query});

  @override
  List<Object?> get props => [query];
}