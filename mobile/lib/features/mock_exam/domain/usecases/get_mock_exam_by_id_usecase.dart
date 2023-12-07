import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class GetMockExamByIdUsecase extends UseCase<Mock, MockExamParams> {
  final MockExamRepository repository;

  GetMockExamByIdUsecase(this.repository);

  @override
  Future<Either<Failure, Mock>> call(MockExamParams params) async {
    return await repository.getMockById(params.id);
  }
}

class MockExamParams extends Equatable {
  final String id;

  const MockExamParams({required this.id});

  @override
  List<Object?> get props => [id];
}
