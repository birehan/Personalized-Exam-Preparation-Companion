import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget({
    super.key,
    required this.messageContent,
    required this.isMyMessage,
    required this.time,
  });

  final String messageContent;
  final bool isMyMessage;
  final DateTime time;

  @override
  Widget build(BuildContext context) {
    final formattedTimeWithAmPm = DateFormat('hh:mm a').format(time);

    return Align(
      alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: messageContent == ''
          ? Container()
          : Column(
              crossAxisAlignment: isMyMessage
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: 70.w,
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: isMyMessage ? Colors.white : const Color(0xFF0072FF),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: Radius.circular(isMyMessage ? 20 : 0),
                      bottomRight: Radius.circular(isMyMessage ? 0 : 20),
                    ),
                  ),
                  child: SelectableText(
                    messageContent,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color:
                          isMyMessage ? const Color(0xFF616161) : Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  formattedTimeWithAmPm.toString(),
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF757575),
                  ),
                )
              ],
            ),
    );
  }
}
