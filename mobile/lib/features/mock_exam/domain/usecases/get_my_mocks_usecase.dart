import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class GetMyMocksUsecase extends UseCase<List<UserMock>, GetMyMocksParams> {
  final MockExamRepository repository;

  GetMyMocksUsecase(this.repository);

  @override
  Future<Either<Failure, List<UserMock>>> call(GetMyMocksParams params) async {
    return await repository.getMyMocks(
      isRefreshed: params.isRefreshed,
    );
  }
}

class GetMyMocksParams extends Equatable {
  final bool isRefreshed;

  const GetMyMocksParams({
    required this.isRefreshed,
  });

  @override
  List<Object?> get props => [isRefreshed];
}
