import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skill_bridge_mobile/core/core.dart';
import 'package:skill_bridge_mobile/features/bookmarks/presentation/bloc/addQuestionBookmarkBloc/add_question_bookmark_bloc.dart';
import 'package:skill_bridge_mobile/features/bookmarks/presentation/bloc/bookmarksBoc/bookmarks_bloc_bloc.dart';
import 'package:skill_bridge_mobile/features/bookmarks/presentation/bloc/deleteQuestionBookmarkBloc/delete_question_bookmark_bloc.dart';
import 'package:skill_bridge_mobile/features/feedback/presentation/widgets/flag_dialogue_box.dart';

import '../../../features.dart';
import 'bookmark_choose_option_card.dart';

class QuestionBookmarkQuizSectionCard extends StatefulWidget {
  const QuestionBookmarkQuizSectionCard({
    super.key,
    required this.question,
    required this.userAnswer,
  });

  final Question question;
  final UserAnswer userAnswer;

  @override
  State<QuestionBookmarkQuizSectionCard> createState() =>
      _QuestionBookmarkQuizSectionCardState();
}

class _QuestionBookmarkQuizSectionCardState
    extends State<QuestionBookmarkQuizSectionCard> {
  bool bookmarked = true;

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
                    IconButton(
                      onPressed: () {
                        if (bookmarked) {
                          context.read<DeleteQuestionBookmarkBloc>().add(
                              QeustionBookmarkDeletedEvent(
                                  questionId: widget.question.id));
                        } else {
                          context.read<AddQuestionBookmarkBloc>().add(
                              QuestionBookmarkAddedEvent(
                                  questionId: widget.question.id));
                        }
                        setState(() {
                          bookmarked = !bookmarked;
                        });
                        context
                            .read<BookmarksBlocBloc>()
                            .add(GetBookmarksEvent());
                      },
                      icon: bookmarked
                          ? const Icon(Icons.bookmark, color: Color(0xffFEA800))
                          : const Icon(Icons.bookmark_outline),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: BookmarkChooseOptionCard(
                    isWrongAnswer: widget.userAnswer.userAnswer == 'choice_A' &&
                        widget.question.answer != 'choice_A',
                    choice: widget.question.choiceA,
                    label: 'A. ',
                    isSelected: widget.question.answer == 'choice_A',
                    onTap: () {},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: BookmarkChooseOptionCard(
                    isWrongAnswer: widget.userAnswer.userAnswer == 'choice_B' &&
                        widget.question.answer != 'choice_B',
                    choice: widget.question.choiceA,
                    label: 'B. ',
                    isSelected: widget.question.answer == 'choice_B',
                    onTap: () {},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: BookmarkChooseOptionCard(
                    isWrongAnswer: widget.userAnswer.userAnswer == 'choice_C' &&
                        widget.question.answer != 'choice_C',
                    choice: widget.question.choiceA,
                    label: 'C. ',
                    isSelected: widget.question.answer == 'choice_C',
                    onTap: () {},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: BookmarkChooseOptionCard(
                    isWrongAnswer: widget.userAnswer.userAnswer == 'choice_D' &&
                        widget.question.answer != 'choice_D',
                    choice: widget.question.choiceA,
                    label: 'D. ',
                    isSelected: widget.question.answer == 'choice_D',
                    onTap: () {},
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
