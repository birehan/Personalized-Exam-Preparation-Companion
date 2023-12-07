import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../features.dart';

class SubtopicQuestionSection extends StatefulWidget {
  const SubtopicQuestionSection({
    super.key,
    required this.question,
    required this.currentIndex,
    required this.totalQuestions,
    required this.userChoice,
    required this.onAnswerSelected,
    required this.isAnswerSelected,
    required this.isWrongAnswer,
  });

  final int currentIndex;
  final int totalQuestions;
  final Question question;
  final String userChoice;
  final bool isWrongAnswer;
  final Function(String) onAnswerSelected;
  final bool isAnswerSelected;

  @override
  State<SubtopicQuestionSection> createState() => _SubtopicQuestionSectionState();
}

class _SubtopicQuestionSectionState extends State<SubtopicQuestionSection> {
  int selectedIndex = 5;

  @override
  Widget build(BuildContext context) {
    return Padding(
       padding: const EdgeInsets.symmetric(horizontal: 16),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Text(
             'Question ${widget.currentIndex + 1} OF ${widget.totalQuestions}',
             style: GoogleFonts.poppins(
               fontSize: 16,
               fontWeight: FontWeight.w500,
               color: const Color(0xFF7E7E7E),
             ),
           ),
           const SizedBox(height: 12),
           Text(
             widget.question.description,
             style: GoogleFonts.poppins(
               fontSize: 18,
               fontWeight: FontWeight.w600,
               color: const Color(0xFF363636),
             ),
           ),
           const SizedBox(height: 16),
           Column(
             children: [
               ChoiceWidget('choice_A',0, 'A. ', widget.question.choiceA),
               ChoiceWidget('choice_B',1, 'B. ', widget.question.choiceB),
               ChoiceWidget('choice_C',2, 'C. ', widget.question.choiceC),
               ChoiceWidget('choice_D',3, 'D. ', widget.question.choiceD),
             ],
           )
         ],
       ),
     );
  }

  Widget ChoiceWidget(String choice, int i, String label, String questionChoice) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SubtopicChooseOption(
        isWrongAnswer: widget.isAnswerSelected ?
            widget.userChoice == choice && widget.question.answer != choice : false,
        isAnswerSelected: widget.isAnswerSelected,
        choice: questionChoice,
        label: label,
        isSelected: widget.isAnswerSelected ? widget.question.answer == choice : false,
        onTap: () {
          setState(() {
            selectedIndex = i;
          });
          widget.onAnswerSelected(choice);

        },
      ),
    );
  }
}
