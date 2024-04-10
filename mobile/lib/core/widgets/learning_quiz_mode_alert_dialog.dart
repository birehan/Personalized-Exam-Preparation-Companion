import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core.dart';

class LearningQuizModeDialog extends StatefulWidget {
  const LearningQuizModeDialog({
    super.key,
    required this.examId,
    this.questionNumber,
  });

  final String examId;
  final int? questionNumber;

  @override
  State<LearningQuizModeDialog> createState() => _LearningQuizModeDialogState();
}

class _LearningQuizModeDialogState extends State<LearningQuizModeDialog> {
  QuestionMode isLearningMode = QuestionMode.none;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Exam Mode',
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomRadioButton(
            title: 'Learning mode',
            description: 'See the answer as soon as you select a choice.',
            isSelected: isLearningMode == QuestionMode.learning,
            onTap: () {
              setState(() {
                isLearningMode = QuestionMode.learning;
              });
            },
          ),
          const SizedBox(height: 12),
          CustomRadioButton(
            title: 'Quiz mode',
            description: 'See the answer after completing the exam.',
            isSelected: isLearningMode == QuestionMode.quiz,
            onTap: () {
              setState(() {
                isLearningMode = QuestionMode.quiz;
              });
            },
          ),
        ],
      ),
      actions: <Widget>[
        Align(
          alignment: Alignment.center,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(36),
            )),
            onPressed: isLearningMode == QuestionMode.none
                ? null
                : () {
                    context.read<AlertDialogBloc>().add(
                          LearningQuizModeEvent(
                              examId: widget.examId,
                              questionMode: isLearningMode,
                              questionNumber: widget.questionNumber),
                        );
                    Navigator.of(context).pop();
                  },
            child: Text(
              'Start',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomRadioButton extends StatelessWidget {
  const CustomRadioButton({
    super.key,
    required this.isSelected,
    required this.title,
    required this.description,
    required this.onTap,
  });

  final bool isSelected;
  final String title;
  final String description;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF18786A) : null,
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF18786A).withOpacity(.5)
                    : Colors.grey,
              ),
              shape: BoxShape.circle,
            ),
            child: isSelected
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 14,
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.6,
                ),
                child: Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
