import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:prep_genie/features/question/presentation/widgets/message_widget__loading.dart';
import '../../../../core/utils/snack_bar.dart';
import '../widgets/message_widget.dart';

import '../../../features.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
    required this.questionId,
    required this.isChatWithContent,
    this.isContest = false,
    this.question,
  });

  final bool isContest;
  final String questionId;
  final bool isChatWithContent;
  final String? question;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Message> chatMessages = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (!widget.isChatWithContent) {
      setState(() {
        chatMessages.add(
          Message(
            content: widget.question ?? "not here",
            isMessageFromUser: false,
          ),
        );
      });
    }
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

    return MultiBlocListener(
      listeners: [
        BlocListener<ChatBloc, ChatState>(
          listener: (context, state) {
            if (state is SendChatState && state.status == ChatStatus.loading) {
              onAIChatResponse("loading");
            }

            if (state is SendChatState && state.status == ChatStatus.loaded) {
              chatMessages.removeAt(chatMessages.length - 1);
              onAIChatResponse(state.chatResponse!.messageResponse);
            }

            if (state is SendChatState && state.status == ChatStatus.error) {
              chatMessages.removeAt(chatMessages.length - 1);
              onAIChatResponse(
                  'An unkown error has occured, please try again...');
            }
          },
        ),
        BlocListener<ChatWithContentBloc, ChatWithContentState>(
          listener: (context, state) {
            if (state is SendChatWithContentState &&
                state.status == ChatStatus.error) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(snackBar(state.failure!.errorMessage));
            }
            if (state is SendChatWithContentState &&
                state.status == ChatStatus.loading) {
              onAIChatResponse("loading");
            }

            if (state is SendChatWithContentState &&
                state.status == ChatStatus.loaded) {
              chatMessages.removeAt(chatMessages.length - 1);
              onAIChatResponse(state.chatResponse!.messageResponse);
            }
          },
        ),
      ],
      child: buildWidget(onUserChatSubmit),
    );
  }

  Widget buildWidget(
    Function(String) onSubmit,
  ) {
    return Scaffold(
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
                  color: const Color(0xFFEEEFF3),
                  child: chatMessages.isNotEmpty
                      ? Column(
                          children: List.generate(
                            chatMessages.length,
                            (index) => chatMessages[index].content == 'loading'
                                ? MessageWidgetLoading(
                                    isMyMessage: false,
                                    time: chatMessages[index].time,
                                  )
                                : MessageWidget(
                                    messageContent: chatMessages[index].content,
                                    isMyMessage:
                                        chatMessages[index].isMessageFromUser,
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
          MessageInputField(
            inputEnabled: chatMessages.isEmpty ||
                chatMessages[chatMessages.length - 1].content != 'loading',
            isContest: widget.isContest,
            questionId: widget.questionId,
            chatMessages: chatMessages,
            onSubmit: onSubmit,
            isChatWithContent: widget.isChatWithContent,
          ),
        ],
      ),
    );
  }
}
