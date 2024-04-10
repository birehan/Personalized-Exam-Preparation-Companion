import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class DailyQuizQuestionSection extends StatefulWidget {
  const DailyQuizQuestionSection({
    super.key,
    required this.examId,
    required this.currentIndex,
    required this.totalQuestions,
    required this.question,
    required this.userChoice,
    required this.onAnswerSelected,
    required this.questionMode,
    required this.goTo,
    required this.userAnswers,
    required this.correctAnswers,
    required this.isLiked,
    required this.examType,
    required this.params,
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
  final DailyQuestionPageParams params;

  @override
  State<DailyQuizQuestionSection> createState() => _QuestionSectionState();
}

class _QuestionSectionState extends State<DailyQuizQuestionSection>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void onTap(int index) {
    setState(() {
      _tabController.index =
          widget.questionMode == QuestionMode.quiz ? 0 : index;
    });
  }

  bool showGlow = false;
  void makeShowGlow() {
    setState(() {
      showGlow = !showGlow;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.isLiked);
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.tab,
          onTap: (int index) {
            onTap(index);
            setState(() {
              showGlow = false;
            });
          },
          tabs: [
            Tab(
              child: Text(
                AppLocalizations.of(context)!.question,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  showGlow
                      ? DefaultTextStyle(
                          style: const TextStyle(
                            color: Color(0xff18786a),
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                          child: AnimatedTextKit(
                            animatedTexts: [
                              FlickerAnimatedText(
                                AppLocalizations.of(context)!.explanation,
                              ),
                              FlickerAnimatedText(
                                AppLocalizations.of(context)!.explanation,
                              ),
                              FlickerAnimatedText(
                                AppLocalizations.of(context)!.explanation,
                              ),
                            ],
                          ),
                        )
                      : Text(
                          AppLocalizations.of(context)!.explanation,
                          style: GoogleFonts.poppins(
                            color: widget.questionMode == QuestionMode.quiz
                                ? Colors.grey
                                : Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                  if (widget.questionMode == QuestionMode.quiz)
                    const SizedBox(width: 12),
                  if (widget.questionMode == QuestionMode.quiz)
                    const Icon(
                      Icons.lock,
                      color: Colors.grey,
                      size: 20,
                    ),
                ],
              ),
            ),
          ],
        ),
        Expanded(
          child: TabBarView(
            physics: widget.questionMode == QuestionMode.quiz
                ? const NeverScrollableScrollPhysics()
                : null,
            controller: _tabController,
            children: [
              DailyQuizQuestionWidget(
                showGlow: widget.questionMode != QuestionMode.quiz
                    ? makeShowGlow
                    : null,
                examType: widget.examType,
                examId: widget.examId,
                isLiked: widget.isLiked,
                question: widget.question,
                currentIndex: widget.currentIndex,
                totalQuestions: widget.totalQuestions,
                userChoice: widget.userChoice,
                onAnswerSelected: widget.onAnswerSelected,
                questionMode: widget.questionMode,
                userAnswers: widget.userAnswers,
                goTo: widget.goTo,
                correctAnswers: widget.correctAnswers,
              ),
              DailyQuizExplanationWidget(
                question: widget.question,
                examId: widget.examId,
                questionMode: widget.questionMode,
                params: widget.params,
              )
            ],
          ),
        ),
      ],
    );
  }
}
