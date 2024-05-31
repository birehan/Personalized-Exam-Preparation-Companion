// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/core.dart';
import '../../../features.dart';
import '../../domain/entities/bookmarked_questions.dart';
import '../widgets/question_bookmark_quiz_section_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QuestionBookmarkPage extends StatefulWidget {
  const QuestionBookmarkPage({
    Key? key,
    required this.bookmarkedQuestion,
  }) : super(key: key);

  final BookmarkedQuestions bookmarkedQuestion;

  @override
  State<QuestionBookmarkPage> createState() => _QuestionBookmarkPageState();
}

class _QuestionBookmarkPageState extends State<QuestionBookmarkPage>
    with TickerProviderStateMixin {
  bool showGlow = false;
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

  // void onTap(int index) {
  //   setState(() {
  //     _tabController.index =
  //         widget.questionMode == QuestionMode.quiz ? 0 : index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          AppLocalizations.of(context)!.bookmarked_question,
          style: TextStyle(
              fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.tab,
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
                              color: Colors.blue,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                            child: AnimatedTextKit(
                              animatedTexts: [
                                FlickerAnimatedText(
                                  AppLocalizations.of(context)!.explanation,
                                ),
                              ],
                            ),
                          )
                        : Text(
                            AppLocalizations.of(context)!.explanation,
                          ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                QuestionBookmarkQuizSectionCard(
                  question: widget.bookmarkedQuestion.question,
                  userAnswer: widget.bookmarkedQuestion.userAnswer,
                ),
                ExplanationWidget(
                  question: widget.bookmarkedQuestion.question,
                  examId: '',
                  questionMode: QuestionMode.analysis,
                  bookmarkedQuestions: widget.bookmarkedQuestion,
                  mockType: MockType.bookmarkedQuestion,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
