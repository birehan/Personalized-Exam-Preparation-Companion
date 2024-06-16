import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GoToDownloadsWidget extends StatelessWidget {
  const GoToDownloadsWidget({
    super.key,
    required this.removeWidget,
    required this.goToCourses,
    required this.goToMock,
  });

  final Function() removeWidget;
  final Function() goToCourses;
  final Function() goToMock;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 32, left: 16, right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            spreadRadius: 8,
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () {
                removeWidget();
              },
              icon: const Icon(
                Icons.cancel,
                color: Color(0xFFFF6652),
                size: 32,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            AppLocalizations.of(context)!
                .you_are_currently_offline_would_you_like_to_view_your_downloaded_content,
            // 'You are currently offline. Would you like to view your downloaded content?',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF3E3E3E),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  goToCourses();
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0072FF),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.view_courses,
                    // 'View Courses',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              InkWell(
                onTap: () {
                  goToMock();
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFC107),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.view_mocks,
                    // 'View Mocks',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF3E3E3E),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
