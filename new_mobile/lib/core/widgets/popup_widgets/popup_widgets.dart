import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void showPopupWhenCountdownEnds({
  required BuildContext context,
  required Function onPressed,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        iconPadding: const EdgeInsets.only(right: 12, top: 8),
        icon: Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () {
              // context.read<ContestDetailBloc>().add(GetContestdetailEvent(
              //     contestId: widget
              //         .contestQuestionByCategoryPageparams.contestId));
              // context.read<ContestRankingBloc>().add(GetContestRankingEvent(
              //     contestId: widget
              //         .contestQuestionByCategoryPageparams.contestId));
              // context.read<PopupMenuBloc>().add(TimesUpEvent());
              Navigator.of(context).pop();
              onPressed();
            },
          ),
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/time_machine.png'),
            const SizedBox(height: 12),
            Text(
              'Contest has ended!',
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ],
        ),
        // content: Text(
        //   'You have run out of time to answer the question.',
        //   style: GoogleFonts.poppins(),
        // ),
        // actions: [
        //   TextButton(
        //     onPressed: () {
        //       onSubmit();
        //       onSaveScore();

        //       Navigator.of(context).pop();
        //     },
        //     child: Text(
        //       'OK',
        //       style: GoogleFonts.poppins(),
        //     ),
        //   ),
        // ],
      );
    },
  );
}

void showPopupOnQuitButtonPressed({
  required BuildContext context,
  required Function onQuitPressed,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text(
          'Confirmation Required',
          style: GoogleFonts.poppins(color: Colors.red),
        ),
        content: Text(
          ' Are you sure you want to leave? Your unsaved changes may be lost.',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(),
            ),
          ),
          TextButton(
            onPressed: () {
              // onSubmit();
              // context.read<ContestDetailBloc>().add(GetContestdetailEvent(
              //     contestId:
              //         widget.contestQuestionByCategoryPageparams.contestId));
              // context.read<PopupMenuBloc>().add(QuitExamEvent());
              onQuitPressed();
              Navigator.of(context).pop();
            },
            child: Text(
              'Quit',
              style: GoogleFonts.poppins(color: Colors.red),
            ),
          ),
        ],
      );
    },
  );
}

void showPopupOnCompletingContest({
  required BuildContext context,
  required Function onCompleted,
  required String title,
  required bool isSubmitted,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        iconPadding: const EdgeInsets.only(right: 12, top: 8),
        icon: Align(
          alignment: Alignment.topRight,
          child: IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () {
              // onSubmit();
              // onSaveScore();
              // context.read<ContestDetailBloc>().add(GetContestdetailEvent(
              //     contestId: widget
              //         .contestQuestionByCategoryPageparams.contestId));
              // context.read<PopupMenuBloc>().add(QuitExamEvent());
              Navigator.of(context).pop();
              onCompleted();
            },
          ),
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            isSubmitted
                ? const Icon(Icons.task_alt, color: Color(0xFF0072FF), size: 48)
                : Image.asset('assets/images/time_machine.png'),
            const SizedBox(height: 12),
            Text(
              title,
              // 'Completed successfully!',
              style: GoogleFonts.poppins(
                fontSize: 20,
                color: Colors.black,
                // color: const Color(0xFF0072FF),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        // content: Text(
        //   ' Are you sure you want to leave? Your unsaved changes may be lost.',
        //   style: GoogleFonts.poppins(),
        // ),
        // actions: [
        //   TextButton(
        //     onPressed: () {
        //       Navigator.of(context).pop();
        //     },
        //     child: Text(
        //       'Cancel',
        //       style: GoogleFonts.poppins(),
        //     ),
        //   ),
        //   TextButton(
        //     onPressed: () {
        //       onSubmit();
        //       context.read<PopupMenuBloc>().add(QuitExamEvent());
        //       Navigator.of(context).pop();
        //     },
        //     child: Text(
        //       'Quit',
        //       style: GoogleFonts.poppins(color: Colors.red),
        //     ),
        //   ),
        // ],
      );
    },
  );
}

void showPopupOnCompletingContestAnalysis({
  required BuildContext context,
  required Function onCompleted,
  required String title,
  required bool isSubmitted,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        iconPadding: const EdgeInsets.only(right: 12, top: 8),
        icon: Align(
          alignment: Alignment.topRight,
          child: IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () {
              // onSubmit();
              // onSaveScore();
              // context.read<ContestDetailBloc>().add(GetContestdetailEvent(
              //     contestId: widget
              //         .contestQuestionByCategoryPageparams.contestId));
              // context.read<PopupMenuBloc>().add(QuitExamEvent());
              Navigator.of(context).pop();
              onCompleted();
            },
          ),
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            isSubmitted
                ? const Icon(Icons.task_alt, color: Color(0xFF0072FF), size: 48)
                : Image.asset('assets/images/time_machine.png'),
            const SizedBox(height: 12),
            Text(
              title,
              // 'Completed successfully!',
              style: GoogleFonts.poppins(
                fontSize: 20,
                color: Colors.black,
                // color: const Color(0xFF0072FF),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        // content: Text(
        //   ' Are you sure you want to leave? Your unsaved changes may be lost.',
        //   style: GoogleFonts.poppins(),
        // ),
        // actions: [
        //   TextButton(
        //     onPressed: () {
        //       Navigator.of(context).pop();
        //     },
        //     child: Text(
        //       'Cancel',
        //       style: GoogleFonts.poppins(),
        //     ),
        //   ),
        //   TextButton(
        //     onPressed: () {
        //       onSubmit();
        //       context.read<PopupMenuBloc>().add(QuitExamEvent());
        //       Navigator.of(context).pop();
        //     },
        //     child: Text(
        //       'Quit',
        //       style: GoogleFonts.poppins(color: Colors.red),
        //     ),
        //   ),
        // ],
      );
    },
  );
}
