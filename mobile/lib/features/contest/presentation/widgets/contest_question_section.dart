import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../features.dart';
import '../../../../core/core.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ContestQuestionSection extends StatefulWidget {
  const ContestQuestionSection({
    super.key,
    required this.examId,
    required this.currentIndex,
    required this.totalQuestions,
    required this.question,
    required this.userChoice,
    required this.onAnswerSelected,
    required this.goTo,
    required this.userAnswers,
    required this.isLiked,
    required this.params,
    this.correctAnswers = const [],
    this.questionMode = QuestionMode.quiz,
  });

  final String examId;
  final int currentIndex;
  final int totalQuestions;
  final ContestQuestion question;
  final String userChoice;
  final Function(String) onAnswerSelected;
  final Function(int) goTo;
  final List<String> userAnswers;
  final List<String> correctAnswers;
  final bool isLiked;
  final QuestionMode questionMode;
  final ContestQuestionByCategoryPageParams params;

  @override
  State<ContestQuestionSection> createState() => _QuestionSectionState();
}

class _QuestionSectionState extends State<ContestQuestionSection>
    with TickerProviderStateMixin {
  late final _tabController;
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      _tabIndex = _tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.questionMode == QuestionMode.analysis
        ? Column(
            children: [
              TabBar(
                controller: _tabController,
                labelColor: Colors.black,
                unselectedLabelColor: const Color(0xFF727171),
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: [
                  Tab(
                    child: Text(
                      AppLocalizations.of(context)!.question,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      AppLocalizations.of(context)!.explanation,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    ContestQuestionWidget(
                      examId: widget.examId,
                      isLiked: widget.isLiked,
                      question: widget.question,
                      currentIndex: widget.currentIndex,
                      totalQuestions: widget.totalQuestions,
                      userChoice: widget.userChoice,
                      onAnswerSelected: widget.onAnswerSelected,
                      userAnswers: widget.userAnswers,
                      goTo: widget.goTo,
                      correctAnswers: widget.correctAnswers,
                      questionMode: widget.questionMode,
                    ),
                    ContestExplanationWidget(
                      question: widget.question,
                      questionMode: QuestionMode.analysis,
                      params: widget.params,
                    )
                  ],
                ),
              ),
            ],
          )
        : ContestQuestionWidget(
            examId: widget.examId,
            isLiked: widget.isLiked,
            question: widget.question,
            currentIndex: widget.currentIndex,
            totalQuestions: widget.totalQuestions,
            userChoice: widget.userChoice,
            onAnswerSelected: widget.onAnswerSelected,
            userAnswers: widget.userAnswers,
            goTo: widget.goTo,
            correctAnswers: widget.correctAnswers,
            questionMode: widget.questionMode,
          );
  }
}
