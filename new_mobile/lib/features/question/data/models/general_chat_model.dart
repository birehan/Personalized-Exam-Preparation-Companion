import 'package:skill_bridge_mobile/features/question/domain/entities/general_chat_entity.dart';

class GeneralChatModel extends GeneralChatEntity {
  const GeneralChatModel({
    required super.chatHistory,
  });

  factory GeneralChatModel.fromJson(Map<String, dynamic> json) {
    return GeneralChatModel(chatHistory: json['history']);
  }
}
