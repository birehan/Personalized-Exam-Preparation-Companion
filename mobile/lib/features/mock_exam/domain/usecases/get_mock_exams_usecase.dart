import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class GetMockExamsUsecase extends UseCase<List<MockExam>, GetMockExamsParams> {
  final MockExamRepository repository;

  GetMockExamsUsecase({
    required this.repository,
  });

  @override
  Future<Either<Failure, List<MockExam>>> call(
      GetMockExamsParams params) async {
    return await repository.getMocks(
      isRefreshed: params.isRefreshed,
    );
  }
}

class GetMockExamsParams extends Equatable {
  const GetMockExamsParams({
    required this.isRefreshed,
  });

  final bool isRefreshed;

  @override
  List<Object?> get props => [isRefreshed];
}
