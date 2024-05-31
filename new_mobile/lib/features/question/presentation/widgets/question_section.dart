import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class QuestionSection extends StatefulWidget {
  const QuestionSection({
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
    this.mockType,
    this.courseName,
    this.courseImage,
    this.isStandard,
  });

  final String examId;
  final int currentIndex;
  final int totalQuestions;
  final Question question;
  final String userChoice;
  final Function(String) onAnswerSelected;
  final QuestionMode questionMode;
  final Function(int) goTo;
  final List<String> userAnswers;
  final List<String> correctAnswers;
  final bool isLiked;
  final ExamType examType;
  final MockType? mockType;
  final String? courseName;
  final String? courseImage;
  final bool? isStandard;

  @override
  State<QuestionSection> createState() => _QuestionSectionState();
}

class _QuestionSectionState extends State<QuestionSection>
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
                            repeatForever: true,
                            animatedTexts: [
                              FlickerAnimatedText(
                                AppLocalizations.of(context)!.explanation,
                                speed: const Duration(milliseconds: 2000),
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
              QuestionWidget(
                showGlow: widget.questionMode != QuestionMode.quiz
                    ? makeShowGlow
                    : null,
                examType: widget.examType,
                mockType: widget.mockType,
                courseName: widget.courseName,
                courseImage: widget.courseImage,
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
              ExplanationWidget(
                question: widget.question,
                examType: widget.examType,
                mockType: widget.mockType,
                examId: widget.examId,
                questionMode: widget.questionMode,
                courseImage: widget.courseImage,
                courseName: widget.courseName,
                isStandard: widget.isStandard,
              )
            ],
          ),
        ),
      ],
    );
  }
}
