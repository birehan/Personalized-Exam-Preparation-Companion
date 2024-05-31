part of 'general_chat_bloc.dart';

class GeneralChatState extends Equatable {
  const GeneralChatState();

  @override
  List<Object> get props => [];
}

class GeneralChatInitial extends GeneralChatState {}

// class GeneralChatLoadedState extends GeneralChatState {
//   final GeneralChatEntity generalChatEntity;

//   const GeneralChatLoadedState({required this.generalChatEntity});
//   @override
//   List<Object> get props => [
//         generalChatEntity,
//       ];
// }

// class GeneralChatLoadingState extends GeneralChatState {
//   final GeneralChatEntity generalChatEntity;

//   const GeneralChatLoadingState({required this.generalChatEntity});
// @override
// List<Object> get props => [
//       generalChatEntity,
//     ];
// }
class GeneralChatLoadingState extends GeneralChatState {}

class GeneralChatLoadedState extends GeneralChatState {
  final ChatResponse chatResponse;

  const GeneralChatLoadedState({required this.chatResponse});
  @override
  List<Object> get props => [
        chatResponse,
      ];
}

class GeneralChatFailedState extends GeneralChatState {
  final Failure failure;

  const GeneralChatFailedState({required this.failure});
}
