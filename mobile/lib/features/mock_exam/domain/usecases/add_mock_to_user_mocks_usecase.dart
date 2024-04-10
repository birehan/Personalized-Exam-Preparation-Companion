import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class AddMockToUserMocksUsecase extends UseCase<void, AddMockToUserMocksParams> {
  final MockExamRepository repository;

  AddMockToUserMocksUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(params) async {
    return await repository.addMocktoUserMocks(
      params.mockId
    );
  }
}

class AddMockToUserMocksParams extends Equatable {
  final String mockId;


  const AddMockToUserMocksParams({
    required this.mockId,
  });

  @override
  List<Object?> get props => [
        mockId,
      ];
}
