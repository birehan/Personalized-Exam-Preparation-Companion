import 'package:flutter/material.dart';
// import 'package:flutter_tex/flutter_tex.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:prep_genie/features/feedback/presentation/widgets/flag_dialogue_box.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class ContestQuestionWidget extends StatefulWidget {
  const ContestQuestionWidget({
    super.key,
    required this.examId,
    required this.question,
    required this.currentIndex,
    required this.totalQuestions,
    required this.userChoice,
    required this.onAnswerSelected,
    required this.userAnswers,
    required this.goTo,
    required this.isLiked,
    required this.correctAnswers,
    required this.questionMode,
  });

  final String examId;
  final int currentIndex;
  final int totalQuestions;
  final ContestQuestion question;
  final String userChoice;
  final Function(String) onAnswerSelected;
  final Function(int) goTo;
  final List<String> userAnswers;
  final bool isLiked;
  final List<String> correctAnswers;
  final QuestionMode questionMode;

  @override
  State<ContestQuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<ContestQuestionWidget> {
  int selectedIndex = 5;
  late bool bookmarked;

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.jump_to_question,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF363636),
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.skip_detail,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF666666),
                  ),
                ),
                Wrap(
                  children: List.generate(
                    widget.userAnswers.length,
                    (index) => Padding(
                      padding: const EdgeInsets.all(4),
                      child: InkWell(
                        onTap: () {
                          widget.goTo(index);
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  // widget.questionMode != QuestionMode.analysis
                                  //     ?
                                  widget.questionMode == QuestionMode.quiz
                                      ? widget.userAnswers[index]
                                                  .toLowerCase() !=
                                              'choice_e'
                                          ? const Color(0xFF0072FF)
                                          : const Color(0xFFEDEDED)
                                      : widget.userAnswers[index]
                                                  .toLowerCase() ==
                                              widget.correctAnswers[index]
                                                  .toLowerCase()
                                          ? const Color(0xFF0072FF)
                                          : Colors.red
                              // : widget.userAnswers[index].toLowerCase() ==
                              //         widget.correctAnswers[index]
                              //             .toLowerCase()
                              //     ? const Color(0xFF0072FF)
                              //     : Colors.red,
                              ),
                          child: Text(
                            '${index + 1}',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color:
                                  (widget.questionMode == QuestionMode.quiz &&
                                              widget.userAnswers[index]
                                                      .toLowerCase() !=
                                                  'choice_e') ||
                                          (widget.questionMode ==
                                              QuestionMode.analysis) ||
                                          (widget.questionMode ==
                                                  QuestionMode.learning &&
                                              widget.userAnswers[index]
                                                      .toLowerCase() !=
                                                  'choice_e')
                                      ? Colors.white
                                      : const Color(0xFF2E2E2E),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      bookmarked = widget.isLiked;
    });

    print(
        'userChoice: ${widget.userChoice}, answer: ${widget.question.answer}');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${AppLocalizations.of(context)!.question} ${widget.currentIndex + 1} ${AppLocalizations.of(context)!.of_text} ${widget.totalQuestions}',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF7E7E7E),
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
                    // IconButton(
                    //     onPressed: () {
                    //       if (bookmarked) {
                    //         context.read<DeleteQuestionBookmarkBloc>().add(
                    //             QeustionBookmarkDeletedEvent(
                    //                 questionId: widget.question.id));
                    //       } else {
                    //         context.read<AddQuestionBookmarkBloc>().add(
                    //             QuestionBookmarkAddedEvent(
                    //                 questionId: widget.question.id));
                    //       }
                    //       setState(() {
                    //         bookmarked = !bookmarked;
                    //       });
                    //     },
                    //     icon: bookmarked
                    //         ? const Icon(Icons.bookmark,
                    //             color: Color(0xffFEA800))
                    //         : const Icon(Icons.bookmark_outline))
                  ],
                ),
                const SizedBox(height: 12),
                // Expanded(
                //   child: MarkdownWidget(
                //     data: widget.question.description,
                //     config: MarkdownConfig.defaultConfig,
                //     markdownGenerator: MarkdownGenerator(
                //       generators: [latexGenerator],
                //       inlineSyntaxList: [LatexSyntax()],
                //       richTextBuilder: (span) => Text.rich(span),
                //     ),
                //   ),
                // ),
                MarkdownWidget(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  data: widget.question.description,
                  config: MarkdownConfig.defaultConfig,
                  markdownGenerator: MarkdownGenerator(
                    generators: [latexGenerator],
                    inlineSyntaxList: [LatexSyntax()],
                    richTextBuilder: (span) => Text.rich(
                      span,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF363636),
                      ),
                    ),
                  ),
                ),
                // Text(
                //   widget.question.description,
                //   style: GoogleFonts.poppins(
                //     fontSize: 16,
                //     fontWeight: FontWeight.w600,
                //     color: const Color(0xFF363636),
                //   ),
                // ),
                // TeXView(
                //   child: TeXViewMarkdown(
                //     """<p>${widget.question.description}</p>""",
                //     style: TeXViewStyle(
                //       fontStyle: TeXViewFontStyle(
                //         fontFamily: 'Poppins',
                //         fontSize: 16,
                //         fontWeight: TeXViewFontWeight.w500,
                //       ),
                //       contentColor: const Color(0xFF212121),
                //     ),
                //   ),
                // ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ContestChooseOption(
                    questionMode: widget.questionMode,
                    isAnswerSelected:
                        widget.userChoice.toLowerCase() != 'choice_e',
                    isWrongAnswer: widget.questionMode == QuestionMode.quiz
                        ? false
                        : widget.userChoice.toLowerCase() == 'choice_a' &&
                            widget.question.answer.toLowerCase() != 'choice_a',
                    choice: widget.question.choiceA,
                    label: 'A. ',
                    isSelected: widget.questionMode == QuestionMode.quiz
                        ? widget.userChoice.toLowerCase() == 'choice_a'
                        : widget.question.answer.toLowerCase() == 'choice_a',
                    onTap: () {
                      setState(() {
                        selectedIndex = 0;
                      });
                      widget.onAnswerSelected('choice_a');
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ContestChooseOption(
                    questionMode: widget.questionMode,
                    isAnswerSelected:
                        widget.userChoice.toLowerCase() != 'choice_e',
                    isWrongAnswer: widget.questionMode == QuestionMode.quiz
                        ? false
                        : widget.userChoice.toLowerCase() == 'choice_b' &&
                            widget.question.answer.toLowerCase() != 'choice_b',
                    choice: widget.question.choiceB,
                    label: 'B. ',
                    isSelected: widget.questionMode == QuestionMode.quiz
                        ? widget.userChoice.toLowerCase() == 'choice_b'
                        : widget.question.answer.toLowerCase() == 'choice_b',
                    onTap: () {
                      setState(() {
                        selectedIndex = 1;
                      });
                      widget.onAnswerSelected('choice_b');
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ContestChooseOption(
                    questionMode: widget.questionMode,
                    isAnswerSelected:
                        widget.userChoice.toLowerCase() != 'choice_e',
                    isWrongAnswer: widget.questionMode == QuestionMode.quiz
                        ? false
                        : widget.userChoice.toLowerCase() == 'choice_c' &&
                            widget.question.answer.toLowerCase() != 'choice_c',
                    choice: widget.question.choiceC,
                    label: 'C. ',
                    isSelected: widget.questionMode == QuestionMode.quiz
                        ? widget.userChoice.toLowerCase() == 'choice_c'
                        : widget.question.answer.toLowerCase() == 'choice_c',
                    onTap: () {
                      setState(() {
                        selectedIndex = 2;
                      });
                      widget.onAnswerSelected('choice_c');
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ContestChooseOption(
                    questionMode: widget.questionMode,
                    isAnswerSelected:
                        widget.userChoice.toLowerCase() != 'choice_e',
                    isWrongAnswer: widget.questionMode == QuestionMode.quiz
                        ? false
                        : widget.userChoice.toLowerCase() == 'choice_d' &&
                            widget.question.answer.toLowerCase() != 'choice_d',
                    choice: widget.question.choiceD,
                    label: 'D. ',
                    isSelected: widget.questionMode == QuestionMode.quiz
                        ? widget.userChoice.toLowerCase() == 'choice_d'
                        : widget.question.answer.toLowerCase() == 'choice_d',
                    onTap: () {
                      setState(() {
                        selectedIndex = 3;
                      });
                      widget.onAnswerSelected('choice_d');
                    },
                  ),
                )
              ],
            ),
            const SizedBox(height: 24),
            InkWell(
              onTap: () {
                _showBottomSheet(context);
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(36),
                  color: const Color(0xFF0072FF).withOpacity(.1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.skip_to,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0072FF),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.fast_forward_rounded,
                      color: Color(0xFF0072FF),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }
}
