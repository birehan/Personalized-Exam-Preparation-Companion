import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:prep_genie/core/error/failure.dart';
import 'package:prep_genie/features/features.dart';
import 'package:prep_genie/features/question/domain/domain.dart';
import 'package:prep_genie/features/question/domain/entities/general_chat_entity.dart';
import 'package:prep_genie/features/question/domain/usecases/general_chat_usecase.dart';

part 'general_chat_event.dart';
part 'general_chat_state.dart';

class GeneralChatBloc extends Bloc<GeneralChatEvent, GeneralChatState> {
  final GeneralChatUsecase generalChatUsecase;
  GeneralChatBloc({required this.generalChatUsecase})
      : super(GeneralChatLoadingState()) {
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
