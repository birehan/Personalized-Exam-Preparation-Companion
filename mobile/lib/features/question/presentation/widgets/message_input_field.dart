import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../features.dart';

class MessageInputField extends StatefulWidget {
  const MessageInputField({
    super.key,
    required this.isContest,
    required this.questionId,
    required this.isChatWithContent,
    required this.chatMessages,
    required this.onSubmit,
    required this.inputEnabled,
  });

  final bool isContest;
  final String questionId;
  final bool isChatWithContent;
  final List<Message> chatMessages;
  final Function(String) onSubmit;
  final bool inputEnabled;

  @override
  State<MessageInputField> createState() => _MessageInputFieldState();
}

class _MessageInputFieldState extends State<MessageInputField> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  List<ChatHistory> generateChatHistory(List<Message> chatMessages) {
    List<ChatHistory> chatHistory = [];
    for (int index = 0; index < chatMessages.length; index++) {
      if (index % 2 == 0) {
        chatHistory.add(
          ChatHistory(
            human: chatMessages[index].content,
            ai: '',
          ),
        );
      } else {
        chatHistory[chatHistory.length - 1] =
            chatHistory[chatHistory.length - 1]
                .copyWith(ai: chatMessages[index].content);
      }
    }

    return chatHistory;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFEEEFF3),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      child: Row(
        children: [
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 120,
              ),
              child: TextField(
                enabled: widget.inputEnabled,
                controller: _messageController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(12),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Ask any question...',
                  border: OutlineInputBorder(
                    // borderRadius: BorderRadius.circular(32),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 24),
          InkWell(
            onTap:
                //! I have no idea why this code used
                // widget.chatMessages.length % 2 == 1
                //     ? null
                //     :
                () {
              if (widget.isChatWithContent) {
                context.read<ChatWithContentBloc>().add(
                      SendChatWithContentEvent(
                        chatBody: ChatBody(
                          isContest: widget.isContest,
                          questionId: widget.questionId,
                          userQuestion: _messageController.text,
                          chatHistory: generateChatHistory(widget.chatMessages),
                        ),
                      ),
                    );
              } else {
                context.read<ChatBloc>().add(
                      SendChatEvent(
                        chatBody: ChatBody(
                          isContest: widget.isContest,
                          questionId: widget.questionId,
                          userQuestion: _messageController.text,
                          chatHistory: generateChatHistory(widget.chatMessages),
                        ),
                      ),
                    );
              }
              widget.onSubmit(_messageController.text);
              _messageController.text = '';
              FocusScope.of(context).unfocus();
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF16786A),
              ),
              child: const Icon(
                Icons.send_rounded,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
