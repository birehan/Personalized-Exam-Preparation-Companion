import 'package:dartz/dartz.dart';
import 'package:skill_bridge_mobile/core/core.dart';

import '../../../features.dart';

class GetMockRankUsecase extends UseCase<MockDetail, String> {
  GetMockRankUsecase({required this.repository});

  final MockExamRepository repository;

  @override
  Future<Either<Failure, MockDetail>> call(String params) async {
    return await repository.getMockDetail(params);
  }
}
