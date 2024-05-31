import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:skill_bridge_mobile/core/core.dart';

import '../../../features.dart';

class GetMockDetailUsecase extends UseCase<MockDetail, GetMockDetailParams> {
  GetMockDetailUsecase({
    required this.repository,
  });

  final MockExamRepository repository;

  @override
  Future<Either<Failure, MockDetail>> call(GetMockDetailParams params) async {
    return await repository.getMockDetail(params.mockId);
  }
}

class GetMockDetailParams extends Equatable {
  const GetMockDetailParams({
    required this.mockId,
  });

  final String mockId;

  @override
  List<Object?> get props => [mockId];
}
