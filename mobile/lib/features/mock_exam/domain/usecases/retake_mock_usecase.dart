import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:prepgenie/core/core.dart';
import 'package:prepgenie/features/features.dart';

class RetakeMockUsecase extends UseCase<void, RetakeMockParams> {
  final MockExamRepository mockExamRepository;

  RetakeMockUsecase({
    required this.mockExamRepository,
  });

  @override
  Future<Either<Failure, void>> call(RetakeMockParams params) async {
    return await mockExamRepository.retakeMock(params.mockId);
  }
}

class RetakeMockParams extends Equatable {
  final String mockId;

  const RetakeMockParams({
    required this.mockId,
  });

  @override
  List<Object?> get props => [mockId];
}
