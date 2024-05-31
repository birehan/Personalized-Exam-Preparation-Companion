import 'package:flutter/material.dart';
// import 'package:flutter_tex/flutter_tex.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:markdown_widget/widget/markdown.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:skill_bridge_mobile/features/feedback/presentation/widgets/flag_dialogue_box.dart';

import '../../../../core/core.dart';
import '../../../bookmarks/presentation/bloc/addQuestionBookmarkBloc/add_question_bookmark_bloc.dart';
import '../../../bookmarks/presentation/bloc/deleteQuestionBookmarkBloc/delete_question_bookmark_bloc.dart';
import '../../../features.dart';

class DailyQuizQuestionWidget extends StatefulWidget {
  const DailyQuizQuestionWidget({
    super.key,
    required this.examId,
    required this.question,
    required this.currentIndex,
    required this.totalQuestions,
    required this.userChoice,
    required this.onAnswerSelected,
    required this.questionMode,
    required this.userAnswers,
    required this.goTo,
    required this.correctAnswers,
    required this.isLiked,
    required this.examType,
    this.showGlow,
  });

  final String examId;
  final int currentIndex;
  final int totalQuestions;
  final DailyQuizQuestion question;
  final String userChoice;
  final Function(String) onAnswerSelected;
  final QuestionMode questionMode;
  final Function(int) goTo;
  final List<String> userAnswers;
  final List<String> correctAnswers;
  final bool isLiked;
  final ExamType examType;
  final Function()? showGlow;

  @override
  State<DailyQuizQuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<DailyQuizQuestionWidget> {
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
                            color: widget.questionMode != QuestionMode.analysis
                                ? widget.questionMode == QuestionMode.quiz
                                    ? widget.userAnswers[index].toLowerCase() !=
                                            'choice_e'
                                        ? const Color(0xFF18786A)
                                        : const Color(0xFFEDEDED)
                                    : widget.userAnswers[index].toLowerCase() ==
                                            'choice_e'
                                        ? const Color(0xFFEDEDED)
                                        : widget.userAnswers[index]
                                                    .toLowerCase() ==
                                                widget.correctAnswers[index]
                                                    .toLowerCase()
                                            ? const Color(0xFF18786A)
                                            : Colors.red
                                : widget.userAnswers[index].toLowerCase() ==
                                        widget.correctAnswers[index]
                                            .toLowerCase()
                                    ? const Color(0xFF18786A)
                                    : Colors.red,
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
  }

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
                    Row(
                      children: [
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
                            },
                            icon: bookmarked
                                ? const Icon(Icons.bookmark,
                                    color: Color(0xffFEA800))
                                : const Icon(Icons.bookmark_outline))
                      ],
                    ),
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
                // Text(
                //   widget.question.description,
                //   style: GoogleFonts.poppins(
                //     fontSize: 16,
                //     fontWeight: FontWeight.w600,
                //     color: const Color(0xFF363636),
                //   ),
                // ),
                MarkdownWidget(
                  shrinkWrap: true,
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
                  child: ChooseOption(
                    isAnswerSelected:
                        widget.userChoice.toLowerCase() != 'choice_e',
                    isWrongAnswer: widget.questionMode == QuestionMode.quiz
                        ? false
                        : widget.userChoice.toLowerCase() == 'choice_a' &&
                            widget.question.answer!.toLowerCase() != 'choice_a',
                    questionMode: widget.questionMode,
                    choice: widget.question.choiceA,
                    label: 'A. ',
                    isSelected: widget.questionMode == QuestionMode.quiz
                        ? widget.userChoice.toLowerCase() == 'choice_a'
                        : widget.question.answer!.toLowerCase() == 'choice_a',
                    onTap: () {
                      setState(() {
                        selectedIndex = 0;
                      });
                      widget.onAnswerSelected('choice_a');
                      if (widget.showGlow != null) {
                        widget.showGlow!();
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ChooseOption(
                    isAnswerSelected:
                        widget.userChoice.toLowerCase() != 'choice_e',
                    isWrongAnswer: widget.questionMode == QuestionMode.quiz
                        ? false
                        : widget.userChoice.toLowerCase() == 'choice_b' &&
                            widget.question.answer!.toLowerCase() != 'choice_b',
                    questionMode: widget.questionMode,
                    choice: widget.question.choiceB,
                    label: 'B. ',
                    isSelected: widget.questionMode == QuestionMode.quiz
                        ? widget.userChoice.toLowerCase() == 'choice_b'
                        : widget.question.answer!.toLowerCase() == 'choice_b',
                    onTap: () {
                      setState(() {
                        selectedIndex = 1;
                      });
                      widget.onAnswerSelected('choice_b');
                      if (widget.showGlow != null) {
                        widget.showGlow!();
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ChooseOption(
                    isAnswerSelected:
                        widget.userChoice.toLowerCase() != 'choice_e',
                    isWrongAnswer: widget.questionMode == QuestionMode.quiz
                        ? false
                        : widget.userChoice.toLowerCase() == 'choice_c' &&
                            widget.question.answer!.toLowerCase() != 'choice_c',
                    questionMode: widget.questionMode,
                    choice: widget.question.choiceC,
                    label: 'C. ',
                    isSelected: widget.questionMode == QuestionMode.quiz
                        ? widget.userChoice.toLowerCase() == 'choice_c'
                        : widget.question.answer!.toLowerCase() == 'choice_c',
                    onTap: () {
                      setState(() {
                        selectedIndex = 2;
                      });
                      widget.onAnswerSelected('choice_c');
                      if (widget.showGlow != null) {
                        widget.showGlow!();
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ChooseOption(
                    isAnswerSelected:
                        widget.userChoice.toLowerCase() != 'choice_e',
                    isWrongAnswer: widget.questionMode == QuestionMode.quiz
                        ? false
                        : widget.userChoice.toLowerCase() == 'choice_d' &&
                            widget.question.answer!.toLowerCase() != 'choice_d',
                    questionMode: widget.questionMode,
                    choice: widget.question.choiceD,
                    label: 'D. ',
                    isSelected: widget.questionMode == QuestionMode.quiz
                        ? widget.userChoice.toLowerCase() == 'choice_d'
                        : widget.question.answer!.toLowerCase() == 'choice_d',
                    onTap: () {
                      setState(() {
                        selectedIndex = 3;
                      });
                      widget.onAnswerSelected('choice_d');
                      if (widget.showGlow != null) {
                        widget.showGlow!();
                      }
                    },
                  ),
                )
              ],
            ),
            const SizedBox(height: 24),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     if (!(widget.questionMode == QuestionMode.quiz))
                //       InkWell(
                //         onTap: () {
                //           // context.push(AppRoutes.chatPage,
                //           //     extra: widget.question.id);
                //           if (widget.examType == ExamType.quiz) {
                //             QuizChatWithAIPageRoute(
                //               courseId: widget.question.courseId,
                //               quizId: widget.examId,
                //               questionId: widget.question.id,
                //               $extra: widget.questionMode,
                //             ).go(context);
                //           } else {
                //             switch (widget.mockType) {
                //               case MockType.recommendedMocks:
                //                 RecommendedMockChatWithAIPageRoute(
                //                   mockId: widget.examId,
                //                   questionId: widget.question.id,
                //                   $extra: widget.questionMode,
                //                 ).go(context);
                //                 break;
                //               case MockType.standardMocks:
                //                 StandardMockChatWithAIPageRoute(
                //                   courseImage: widget.courseImage!,
                //                   courseName: widget.courseName!,
                //                   isStandard: true,
                //                   mockId: widget.examId,
                //                   questionId: widget.question.id,
                //                   $extra: widget.questionMode,
                //                 ).go(context);
                //                 break;
                //               case MockType.myStandardMocks:
                //                 MyMockExamChatWithAIPageRoute(
                //                   mockId: widget.examId,
                //                   questionId: widget.question.id,
                //                   $extra: widget.questionMode,
                //                   isStandard: true,
                //                 ).go(context);
                //                 break;
                //               default:
                //                 StandardMockChatWithAIPageRoute(
                //                   courseImage: widget.courseImage!,
                //                   courseName: widget.courseName!,
                //                   isStandard: true,
                //                   mockId: widget.examId,
                //                   questionId: widget.question.id,
                //                   $extra: widget.questionMode,
                //                 ).go(context);
                //                 break;
                //             }
                //           }
                //         },
                //         child: Container(
                //           padding: const EdgeInsets.symmetric(
                //               horizontal: 15, vertical: 12),
                //           decoration: BoxDecoration(
                //             color: const Color.fromRGBO(255, 193, 7, .11),
                //             borderRadius: BorderRadius.circular(16),
                //           ),
                //           child: Row(
                //             children: [
                //               Image.asset('assets/images/ai_bot.png'),
                //               const SizedBox(width: 12),
                //               Text(
                //                 'Chat with AI',
                //                 style: GoogleFonts.poppins(
                //                   fontSize: 15,
                //                   fontWeight: FontWeight.w600,
                //                   color: const Color.fromRGBO(255, 193, 7, 1),
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //     if (widget.questionMode == QuestionMode.quiz) Container(),
                //     UserFeedbackWidget(
                //       onLiked: (l, d) {
                //         setState(() {
                //           liked = l;
                //           disliked = d;
                //         });
                //       },
                //       liked: liked,
                //       isQuizMode: widget.questionMode == QuestionMode.quiz,
                //       question: widget.question,
                //       disliked: disliked,
                //       onDisliked: (l, d) {
                //         setState(() {
                //           liked = l;
                //           disliked = d;
                //         });
                //       },
                //     )
                //   ],
                // ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    onTap: () {
                      _showBottomSheet(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(36),
                        color: const Color(0xFF18786A).withOpacity(.1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // const Icon(
                          //   Icons.help,
                          //   color: Color(0xFF18786A),
                          // ),
                          // const SizedBox(width: 8),
                          Text(
                            'Skip to',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF18786A),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.fast_forward_rounded,
                            color: Color(0xFF18786A),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // if (!widget.isQuizMode)
            //   Column(
            //     children: [
            //       const SizedBox(height: 24),
            //       Padding(
            //         padding: const EdgeInsets.symmetric(
            //           vertical: 2.0,
            //           horizontal: 24,
            //         ),
            //         child: Text(
            //           widget.question.explanation,
            //           textAlign: TextAlign.justify,
            //           style: GoogleFonts.poppins(
            //             fontSize: 16,
            //             fontWeight: FontWeight.w500,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }
}
