import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skill_bridge_mobile/features/question/presentation/pages/typingIndicator.dart';

class MessageWidgetLoading extends StatelessWidget {
  const MessageWidgetLoading({
    super.key,
    required this.isMyMessage,
    required this.time,
  });

  final bool isMyMessage;
  final DateTime time;

  @override
  Widget build(BuildContext context) {
    final formattedTimeWithAmPm = DateFormat('hh:mm a').format(time);

    return Align(
      alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: 30.w,
            ),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: isMyMessage ? Colors.white : const Color(0xFF44A092),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: Radius.circular(isMyMessage ? 20 : 0),
                bottomRight: Radius.circular(isMyMessage ? 0 : 20),
              ),
            ),
            child: TypingIndicator(),
            
            // SelectableText(
            //   "typing",
            //   style: GoogleFonts.poppins(
            //     fontSize: 16,
            //     fontWeight: FontWeight.w500,
            //     color: isMyMessage ? const Color(0xFF616161) : Colors.white,
            //   ),
            // ),
          ),
          const SizedBox(height: 6),
        ],
      ),
    );
  }
}
