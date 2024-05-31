import 'package:dartz/dartz.dart';
import 'package:skill_bridge_mobile/core/core.dart';
import 'package:skill_bridge_mobile/features/features.dart';
import 'package:skill_bridge_mobile/features/question/domain/entities/general_chat_entity.dart';
import 'package:skill_bridge_mobile/features/question/domain/repositories/question_repository.dart';

class GeneralChatUsecase extends UseCase<ChatResponse, GeneralChatParams> {
  final QuestionRepository repository;

  GeneralChatUsecase({required this.repository});
  @override
  Future<Either<Failure, ChatResponse>> call(GeneralChatParams params) async {
    return await repository.sendGeneralChat(chat: params.generalChatEntity);
  }
}

class GeneralChatParams {
  final GeneralChatEntity generalChatEntity;

  GeneralChatParams({required this.generalChatEntity});
}
