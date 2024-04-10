import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class ChatWithContentUsecase extends UseCase<ChatResponse, ChatBody> {
  final CourseRepositories repository;

  ChatWithContentUsecase({required this.repository});

  @override
  Future<Either<Failure, ChatResponse>> call(ChatBody params) async {
    return await repository.chat(
      params.isContest,
      params.questionId,
      params.userQuestion,
      params.chatHistory,
    );
  }
}
