import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markdown_widget/markdown_widget.dart';

import '../../../../core/constants/app_enums.dart';
import '../../../../core/core.dart';
import '../../../../core/routes/go_routes.dart';
import '../../../../core/widgets/floating_options.dart';
import '../../../features.dart';
import '../../../feedback/presentation/widgets/flag_dialogue_box.dart';

class SubtopicQuestionPage extends StatefulWidget {
  const SubtopicQuestionPage({
    super.key,
    required this.questions,
    required this.courseId,
  });

  final List<Question> questions;
  final String courseId;

  @override
  State<SubtopicQuestionPage> createState() => _SubtopicQuestionPageState();
}

class _SubtopicQuestionPageState extends State<SubtopicQuestionPage> {
  List<bool> isAnswerSelected = [];
  List<String> userAnswer = [];
  List<bool> wrongAnswer = [];

  final _pageController = PageController();
  int currentIndex = 0;
  int score = 0;

  @override
  void initState() {
    super.initState();

    isAnswerSelected = widget.questions.map((_) => false).toList();
    userAnswer = widget.questions.map((_) => '').toList();
    wrongAnswer = widget.questions.map((_) => false).toList();

    _pageController.addListener(() {
      setState(() {
        currentIndex = _pageController.page?.round() ?? 0;
      });
    });
  }

  void goTo(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FeedbackBloc, FeedbackState>(
        listener: (context, state) {
          if (state is FeedbackSubmitedState) {
            final snackBar = SnackBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              content: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 4)
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Thank you for your feedback 🙏',
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child: Scaffold(
          // floatingActionButton: FloatingOptions(
          //   hideChat: true,
          //   chatCallback: () {},
          //   flagCallback: () {
          //     showDialog(
          //       context: context,
          //       builder: (BuildContext context) {
          //         return FlagDialog(
          //           index: 0,
          //           id: widget.questions[currentIndex].id,
          //           feedbackType: FeedbackType.questionFeedback,
          //         );
          //       },
          //     );
          //   },
          // ),
          // floatingActionButtonLocation:
          //     const CustomFloatingActionButtonLocation(.8, .8),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: InkWell(
              onTap: () {
                if (currentIndex > 0) {
                  goTo(currentIndex - 1);
                } else {
                  context.pop();
                }

                goTo(currentIndex - 1);
              },
              child: const Icon(
                Icons.keyboard_arrow_left,
                color: Color(0xFF333333),
                size: 32,
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 4,
                vertical: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  Text(
                    'Questions',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFFF6652),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (currentIndex + 1 < widget.questions.length) {
                        goTo(currentIndex + 1);
                      } else {
                        // EndOfChapterPageRoute(courseId: widget.courseId)
                        //     .go(context);
                        EndOfQuestionsResultPageRoute(
                          courseId: widget.courseId,
                          $extra: ResultPageParams(
                              score: score,
                              totalQuestions: widget.questions.length,
                              id: '',
                              examType: ExamType.endOfChapterQuestions,
                              mockType: MockType.recommendedMocks,
                              questionMode: QuestionMode.learning),
                        ).go(context);
                      }
                    },
                    child: const Icon(
                      Icons.keyboard_arrow_right,
                      color: Color(0xFF333333),
                      size: 32,
                    ),
                  )
                ],
              ),
            ),
          ),
          body: Column(children: [
            Row(children: [
              Expanded(
                child: SizedBox(
                  height: 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: (currentIndex + 1) / widget.questions.length,
                      backgroundColor: const Color.fromRGBO(24, 120, 106, 0.1),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFFFF6652),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 16),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.questions.length,
                itemBuilder: (context, index) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        SubtopicQuestionSection(
                            isAnswerSelected: isAnswerSelected[index],
                            question: widget.questions[index],
                            currentIndex: currentIndex,
                            totalQuestions: widget.questions.length,
                            userChoice: userAnswer[index],
                            isWrongAnswer: wrongAnswer[index],
                            onAnswerSelected: (selectedOption) {
                              if (widget.questions[index].answer ==
                                  selectedOption) {
                                setState(() {
                                  score += 1;
                                });
                              }
                              setState(() {
                                userAnswer[index] = selectedOption;
                                wrongAnswer[index] = userAnswer[index] !=
                                    widget.questions[index].answer;
                                isAnswerSelected[index] = true;
                              });
                            }),
                        !isAnswerSelected[index]
                            ? Container()
                            : Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: !wrongAnswer[index]
                                          ? const Color.fromRGBO(
                                              232, 244, 235, 1)
                                          : const Color.fromRGBO(
                                              249, 232, 230, 1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                        horizontal: 12,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8,
                                          horizontal: 12,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            (!wrongAnswer[index]
                                                ? const Icon(
                                                    Icons.check,
                                                    color: Color(0xFF67D181),
                                                    size: 14,
                                                  )
                                                : const Icon(
                                                    Icons.close,
                                                    color: Color.fromARGB(
                                                        175, 255, 7, 7),
                                                    size: 14,
                                                  )),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              !wrongAnswer[index]
                                                  ? 'Correct'
                                                  : 'Incorrect',
                                              style: GoogleFonts.poppins(
                                                color: !wrongAnswer[index]
                                                    ? const Color(0xFF67D181)
                                                    : const Color.fromARGB(
                                                        175, 255, 7, 7),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.0, horizontal: 24),
                                    child: MarkdownWidget(
                                      shrinkWrap: true,
                                      data: widget.questions[index].explanation,
                                      config: MarkdownConfig.defaultConfig,
                                      markdownGenerator: MarkdownGenerator(
                                        generators: [latexGenerator],
                                        inlineSyntaxList: [LatexSyntax()],
                                        richTextBuilder: (span) => Text.rich(
                                          span,
                                          textAlign: TextAlign.justify,
                                          style: GoogleFonts.poppins(),
                                        ),
                                      ),
                                    ),

                                    // child: Text(
                                    //   widget.questions[index].explanation,
                                    //   textAlign: TextAlign.justify,
                                    //   style: GoogleFonts.poppins(),
                                    // ),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ]),
        ));
  }
}
