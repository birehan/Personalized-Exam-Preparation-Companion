// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/core.dart';
import '../../../features.dart';
import '../../domain/entities/bookmarked_questions.dart';
import '../widgets/qeustion_bookmark_quiz_sercion_card.dart';

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
        title: const Text(
          'Bookmarked Question',
          style: TextStyle(
              fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 18),
        ),
        centerTitle: true,
      ),
      // floatingActionButton: FloatingOptions(
      //   flagCallback: () {
      //     showDialog(
      //       context: context,
      //       builder: (BuildContext context) {
      //         return FlagDialog(
      //           index: 0,
      //           id: widget.bookmarkedQuestion.question.id,
      //           feedbackType: FeedbackType.questionFeedback,
      //         );
      //       },
      //     );
      //   },
      //   chatCallback: () {
      //      StandardMockChatWithAIPageRoute
      //        mockId: widget.bookmarkedQuestion.question.id,
      //        questionId: widget.bookmarkedQuestion.question.id,
      //        $extra: QuestionMode.learning,
      //      ).go(context);
      //   },
      // ),
      // floatingActionButtonLocation:
      //     const CustomFloatingActionButtonLocation(.8, .85),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Tab(
                child: Text(
                  'Question',
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
                    Text(
                      'Explanation',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
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
