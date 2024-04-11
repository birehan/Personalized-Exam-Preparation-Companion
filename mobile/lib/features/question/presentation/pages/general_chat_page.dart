import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:prepgenie/features/question/presentation/bloc/bloc/general_chat_bloc.dart';
import 'package:prepgenie/features/question/presentation/widgets/message_input_field_for_generalchat.dart';
import 'package:prepgenie/features/question/presentation/widgets/message_widget__loading.dart';
import '../widgets/message_widget.dart';

import '../../../features.dart';

class GeneralChatPage extends StatefulWidget {
  const GeneralChatPage({
    super.key,
    required this.pageName,
  });

  final String pageName;

  @override
  State<GeneralChatPage> createState() => _GeneralChatPageState();
}

class _GeneralChatPageState extends State<GeneralChatPage> {
  List<Message> chatMessages = [
    Message(content: '', isMessageFromUser: true),
  ];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void onUserChatSubmit(String userMessage) {
      setState(() {
        chatMessages.add(
          Message(content: userMessage, isMessageFromUser: true),
        );
      });
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }

    void onAIChatResponse(String aiChat) {
      setState(() {
        chatMessages.add(
          Message(content: aiChat, isMessageFromUser: false),
        );
      });
      Future.delayed(const Duration(milliseconds: 300), () {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      });
    }

    return BlocListener<GeneralChatBloc, GeneralChatState>(
      listener: (context, state) {
        if (state is GeneralChatLoadingState) {
          onAIChatResponse("loading");
        }

        if (state is GeneralChatLoadedState) {
          chatMessages.removeAt(chatMessages.length - 1);
          onAIChatResponse(state.chatResponse.messageResponse);
        }

        if (state is GeneralChatFailedState) {
          chatMessages.removeAt(chatMessages.length - 1);
          onAIChatResponse('An unkown error has occured, please try again...');
        }
        // else if (state is SendChatState &&
        //     state.status == ChatStatus.loading) {
        //   onAIChatResponse(state.chatResponse!.messageResponse);
        // }
      },
      child: buildWidget(onUserChatSubmit),
    );
  }

  Widget buildWidget(
    Function(String) onSubmit,
  ) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const ChatAppBarWidget(),
            Expanded(
              child: Container(
                color: const Color(0xFFEEEFF3),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Container(
                    width: 100.w,
                    padding: const EdgeInsets.symmetric(
                        vertical: 24, horizontal: 12),
                    color: const Color(0xFFEEEFF3),
                    child: chatMessages.isNotEmpty
                        ? Column(
                            children: List.generate(
                              chatMessages.length,
                              (index) =>
                                  chatMessages[index].content == 'loading'
                                      ? MessageWidgetLoading(
                                          isMyMessage: false,
                                          time: chatMessages[index].time,
                                        )
                                      : MessageWidget(
                                          messageContent:
                                              chatMessages[index].content,
                                          isMyMessage: chatMessages[index]
                                              .isMessageFromUser,
                                          time: chatMessages[index].time,
                                        ),
                            ),
                          )
                        : SizedBox(
                            height: 70.h,
                            child: const Column(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: ChatWelcomeCard(),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
              ),
            ),
            GeneralChatMessageInputField(
              isEnabled: chatMessages.isEmpty ||
                  chatMessages[chatMessages.length - 1].content != 'loading',
              chatMessages: chatMessages,
              pageName: widget.pageName,
              onSubmit: onSubmit,
            ),
          ],
        ),
      ),
    );
  }
}
