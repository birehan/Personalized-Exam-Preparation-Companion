import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:skill_bridge_mobile/core/error/failure.dart';
import 'package:skill_bridge_mobile/features/features.dart';
import 'package:skill_bridge_mobile/features/question/domain/domain.dart';
import 'package:skill_bridge_mobile/features/question/domain/entities/general_chat_entity.dart';
import 'package:skill_bridge_mobile/features/question/domain/usecases/general_chat_usecase.dart';

part 'general_chat_event.dart';
part 'general_chat_state.dart';

class GeneralChatBloc extends Bloc<GeneralChatEvent, GeneralChatState> {
  final GeneralChatUsecase generalChatUsecase;
  GeneralChatBloc({required this.generalChatUsecase})
      : super(GeneralChatLoadingState()) {
    // on<GeneralChatSendEvent>((event, emit) async {
    //   late List<ChatHistory> chatHistory = [];
    //   // if there is chat
    //   if (!event.isFirstChat) {
    //     if (state is GeneralChatLoadedState) {
    //       chatHistory =
    //           (state as GeneralChatLoadedState).generalChatEntity.chatHistory;
    //     }
    //   }
    //   emit(GeneralChatLoadingState(
    //       generalChatEntity: GeneralChatEntity(chatHistory: chatHistory)));
    //   // the message to the
    // final chat = GeneralChatEntity(
    //     chatHistory: chatHistory, userQuestion: event.message);
    //   // send chat
    //   final chatResponse =
    //       await generalChatUsecase(GeneralChatParams(generalChatEntity: chat));
    //   // apend the reponse to the current chat history
    //   chatResponse.fold(
    //     (failure) => emit(GeneralChatFailedState(failure: failure)),
    //     (response) {
    //       final previousChatHistory =
    //           (state as GeneralChatLoadingState).generalChatEntity.chatHistory;
    //       final updatedChatHistory = [
    //         ...previousChatHistory,
    //         ChatHistory(
    //           human: event.message,
    //           ai: response.messageResponse,
    //         ),
    //       ];
    //       return emit(GeneralChatLoadedState(
    //         generalChatEntity: GeneralChatEntity(
    //           chatHistory: updatedChatHistory,
    //         ),
    //       ));
    //     },
    //   );
    //   // emit
    // });
    on<GeneralChatSendEvent>((event, emit) async {
      emit(GeneralChatLoadingState());
      final chat = GeneralChatEntity(
        chatHistory: event.chatHistory,
        userQuestion: event.message,
        pageName: event.pageName,
      );
      final chatResponse = await generalChatUsecase(GeneralChatParams(
        generalChatEntity: chat,
      ));

      chatResponse.fold(
        (l) => emit(GeneralChatFailedState(failure: l)),
        (r) => emit(GeneralChatLoadedState(chatResponse: r)),
      );
    });
  }
}
