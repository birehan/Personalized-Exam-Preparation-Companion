import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class ChatUsecase extends UseCase<ChatResponse, ChatBody> {
  final QuestionRepository repository;

  ChatUsecase({required this.repository});

  @override
  Future<Either<Failure, ChatResponse>> call(ChatBody params) async {
    return await repository.chat(
      params.questionId,
      params.userQuestion,
      params.chatHistory,
      params.isContest,
    );
  }
}
