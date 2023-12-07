import '../../../features.dart';

abstract class HomeLocalDatasource {
  Future<List<UserCourse>> getMyCourses();
  Future<ExamDateModel> getExamDate();
  Future<void> cacheMyCourses(List<UserCourse> courses);
  Future<void> cacheExamDate(ExamDate examDate);
}

class HomeLocalDatasourceImpl implements HomeLocalDatasource {
  @override
  Future<ExamDateModel> getExamDate() {
    // TODO: implement getExamDate
    throw UnimplementedError();
  }

  @override
  Future<List<UserCourse>> getMyCourses() {
    // TODO: implement getMyCourses
    throw UnimplementedError();
  }

  @override
  Future<void> cacheExamDate(ExamDate examDate) {
    // TODO: implement cacheExamDate
    throw UnimplementedError();
  }

  @override
  Future<void> cacheMyCourses(List<UserCourse> courses) {
    // TODO: implement cacheMyCourses
    throw UnimplementedError();
  }
}
