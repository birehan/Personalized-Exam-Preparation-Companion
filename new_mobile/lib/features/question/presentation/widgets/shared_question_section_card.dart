import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skill_bridge_mobile/core/core.dart';
import 'package:skill_bridge_mobile/features/bookmarks/presentation/bloc/addQuestionBookmarkBloc/add_question_bookmark_bloc.dart';
import 'package:skill_bridge_mobile/features/bookmarks/presentation/bloc/bookmarksBoc/bookmarks_bloc_bloc.dart';
import 'package:skill_bridge_mobile/features/bookmarks/presentation/bloc/deleteQuestionBookmarkBloc/delete_question_bookmark_bloc.dart';
import 'package:skill_bridge_mobile/features/bookmarks/presentation/widgets/bookmark_choose_option_card.dart';
import 'package:skill_bridge_mobile/features/feedback/presentation/widgets/flag_dialogue_box.dart';

import '../../../features.dart';

class SharedQuestionSectionCard extends StatefulWidget {
  const SharedQuestionSectionCard({
    super.key,
    required this.question,
  });

  final Question question;

  @override
  State<SharedQuestionSectionCard> createState() =>
      _SharedQuestionSectionCardState();
}

class _SharedQuestionSectionCardState extends State<SharedQuestionSectionCard> {
  bool bookmarked = true;
  String selectedChoice = '';
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.question.description,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF363636),
                        ),
                      ),
                    ),
                    FlagButton(onPressed: () {
                      var originalContext = context;
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return FlagDialog(
                            originalContext: originalContext,
                            index: 0,
                            id: widget.question.id,
                            feedbackType: FeedbackType.questionFeedback,
                          );
                        },
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: BookmarkChooseOptionCard(
                    isWrongAnswer: selectedChoice == 'choice_A' &&
                        widget.question.answer != 'choice_A',
                    choice: widget.question.choiceA,
                    label: 'A. ',
                    isSelected: selectedChoice != '' &&
                        widget.question.answer == 'choice_A',
                    onTap: () {
                      setState(() {
                        selectedChoice = 'choice_A';
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: BookmarkChooseOptionCard(
                    isWrongAnswer: selectedChoice == 'choice_B' &&
                        widget.question.answer != 'choice_B',
                    choice: widget.question.choiceB,
                    label: 'B. ',
                    isSelected: selectedChoice != '' &&
                        widget.question.answer == 'choice_B',
                    onTap: () {
                      setState(() {
                        selectedChoice = 'choice_B';
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: BookmarkChooseOptionCard(
                    isWrongAnswer: selectedChoice == 'choice_C' &&
                        widget.question.answer != 'choice_C',
                    choice: widget.question.choiceC,
                    label: 'C. ',
                    isSelected: selectedChoice != '' &&
                        widget.question.answer == 'choice_C',
                    onTap: () {
                      setState(() {
                        selectedChoice = 'choice_C';
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: BookmarkChooseOptionCard(
                    isWrongAnswer: selectedChoice == 'choice_D' &&
                        widget.question.answer != 'choice_D',
                    choice: widget.question.choiceD,
                    label: 'D. ',
                    isSelected: selectedChoice != '' &&
                        widget.question.answer == 'choice_D',
                    onTap: () {
                      setState(() {
                        selectedChoice = 'choice_D';
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }
}
