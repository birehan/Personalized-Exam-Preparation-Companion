import '../../../features.dart';

class ChatResponseModel extends ChatResponse {
  const ChatResponseModel({
    required super.messageResponse,
  });

  factory ChatResponseModel.fromJson(Map<String, dynamic> json) {
    final responseJson = json['history'] ?? [];
    return ChatResponseModel(
      messageResponse: responseJson[responseJson.length - 1][1],
    );
  }

  @override
  List<Object> get props => [messageResponse];
}
