import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/core.dart';
import '../../../features.dart';
import '../../../mock_exam/presentation/pages/mock_exam_separated_page.dart';

class ResultPageParams extends Equatable {
  final int score;
  final int totalQuestions;
  final String id;
  final ExamType examType;
  final String? courseId;
  final String? courseName;
  final String? courseImage;
  final MockType? mockType;
  final QuestionMode questionMode;
  final DownloadedUserMock? downloadedUserMock;

  const ResultPageParams({
    required this.score,
    required this.totalQuestions,
    required this.id,
    required this.examType,
    this.courseId,
    this.courseName,
    this.courseImage,
    this.mockType,
    required this.questionMode,
    this.downloadedUserMock,
  });

  @override
  List<Object?> get props => [
        score,
        totalQuestions,
        id,
        examType,
        courseId,
        courseName,
        courseImage,
        mockType,
        downloadedUserMock
      ];
}

class ResultPage extends StatefulWidget {
  const ResultPage({
    super.key,
    required this.resultPageParams,
  });

  final ResultPageParams resultPageParams;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  void goToMockAnalysis(MockType mockType) {
    if (widget.resultPageParams.questionMode == QuestionMode.learning) {
      context.pop();
      return;
    }
    if (widget.resultPageParams.courseImage != null ||
        widget.resultPageParams.courseImage == '') {
      UniversityMockExamsQuestionPageRoute(
        mockId: widget.resultPageParams.id,
        courseImage: widget.resultPageParams.courseImage ?? '',
        courseName: widget.resultPageParams.courseName ?? '',
        isStandard: true,
        $extra: MockExamQuestionPageParams(
          completed: false,
          mockId: widget.resultPageParams.id,
          mockType: MockType.standardMocks,
          questionMode: QuestionMode.analysis,
          questionNumber: widget.resultPageParams.totalQuestions,
          courseImage: widget.resultPageParams.courseImage,
          courseName: widget.resultPageParams.courseName,
          isStandard: true,
        ),
      ).go(context);
    } else if (widget.resultPageParams.examType == ExamType.downloadedMock) {
      DownloadedMockExamQuestionPageRoute(
        $extra: DownloadedMockExamQuestionPageParams(
          downloadedUserMock: widget.resultPageParams.downloadedUserMock!,
          questionMode: QuestionMode.analysis,
        ),
      ).go(context);
    } else {
      MyExamsMockQuestionPageRoute(
        mockId: widget.resultPageParams.id,
        $extra: MockExamQuestionPageParams(
          completed: false,
          mockId: widget.resultPageParams.id,
          mockType: MockType.standardMocks,
          questionMode: QuestionMode.analysis,
          questionNumber: widget.resultPageParams.totalQuestions,
          courseImage: widget.resultPageParams.courseImage,
          courseName: widget.resultPageParams.courseName,
          isStandard: true,
        ),
      ).go(context);
    }
    // switch (mockType) {
    //   case MockType.recommendedMocks:
    //     // RecommendedMockPageRoute(
    //     //   mockId: widget.resultPageParams.id,
    //     //   $extra: QuestionMode.analysis,
    //     // ).go(context);
    //     MockQuestionPageRoute(
    //         $extra: MockExamQustionPageParams(
    //       completed: false,
    //       mockId: widget.resultPageParams.id,
    //       mockType: MockType.recommendedMocks,
    //       questionMode: QuestionMode.analysis,
    //       questionNumber: widget.resultPageParams.totalQuestions,
    //       courseImage: widget.resultPageParams.courseImage,
    //       courseName: widget.resultPageParams.courseName,
    //       isStandard: true,
    //     )).go(context);
    //     break;
    //   case MockType.standardMocks:
    //     StandardMockExamsPageRoute(
    //       courseImage: widget.resultPageParams.courseImage!,
    //       courseName: widget.resultPageParams.courseName!,
    //       isStandard: true,
    //       mockId: widget.resultPageParams.id,
    //       $extra: QuestionMode.analysis,
    //     ).go(context);
    //     break;
    //   case MockType.myStandardMocks:
    //     MyMockExamPageRoute(
    //       // isStandard: true,
    //       mockId: widget.resultPageParams.id,
    //       $extra: QuestionMode.analysis,
    //     ).go(context);
    //     break;
    //   case MockType.myAIGeneratedMocks:
    //     StandardMockExamsPageRoute(
    //       courseImage: widget.resultPageParams.courseImage!,
    //       courseName: widget.resultPageParams.courseName!,
    //       isStandard: true,
    //       mockId: widget.resultPageParams.id,
    //       $extra: QuestionMode.analysis,
    //     ).go(context);
    //     break;
    //   default:
    //     break;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return buildResultPageWidget(context);
  }

  Widget buildResultPageWidget(BuildContext context) {
    final Finalwidth = MediaQuery.of(context).size.width;
    final Finalheight = MediaQuery.of(context).size.height;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {},
      child: Scaffold(
        body: BlocListener<QuizQuestionBloc, QuizQuestionState>(
          listener: (context, state) {
            if (state is SaveQuizScoreState &&
                state.status == QuizQuestionStatus.loaded) {
              // here load the quizes for the course to update the state of the quizes
              if (widget.resultPageParams.courseId != null) {
                context.read<QuizBloc>().add(
                      GetUserQuizEvent(
                        courseId: widget.resultPageParams.courseId!,
                        isRefreshed: true,
                      ),
                    );
              }
            }
          },
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/resultBackground.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        context.pop();
                        // for (int index = 0;
                        //     index < resultPageParams.stackHeight;
                        //     index++) {
                        //   context.pop();
                        // }
                        // context.read<PopupMenuBloc>().add(const GoToPageEvent());
                      },
                      child: const XIcon(
                        color: Color(0xFF363636),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              getCompliment(
                                  (widget.resultPageParams.score /
                                          widget.resultPageParams
                                              .totalQuestions) *
                                      100,
                                  widget.resultPageParams),
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF363636),
                              ),
                            ),
                            SizedBox(
                              width: Finalwidth * 0.8,
                              child: Text(
                                getScoreMessage(
                                    (widget.resultPageParams.score /
                                            widget.resultPageParams
                                                .totalQuestions) *
                                        100,
                                    context),
                                textAlign: TextAlign.center,
                                softWrap: true,
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF5D5A6F),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Stack(
                              children: [
                                FillingBar(
                                  progress: ((widget.resultPageParams.score /
                                          widget.resultPageParams
                                              .totalQuestions) *
                                      100),
                                  width: 200,
                                  height: 200,
                                  strokeWidth: 16,
                                ),
                                Positioned(
                                  left: 87,
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFF1A7A6C),
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 80,
                                  left: 87,
                                  child: Center(
                                    child: SizedBox(
                                      child: Column(
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              text:
                                                  '${((widget.resultPageParams.score / widget.resultPageParams.totalQuestions) * 100).toStringAsFixed(0)}%',
                                              style: GoogleFonts.poppins(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w700,
                                                color: const Color(0xFF363636),
                                              ),
                                            ),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              text:
                                                  '${widget.resultPageParams.score} of ${widget.resultPageParams.totalQuestions}',
                                              style: GoogleFonts.poppins(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                color: const Color(0xFF717171),
                                              ),
                                            ),
                                          ),
                                          // Text(
                                          //   '${((resultPageParams.score / resultPageParams.totalQuestions) * 100).toStringAsFixed(0)}%',
                                          //   style: GoogleFonts.poppins(
                                          //     fontSize: 34,
                                          //     fontWeight: FontWeight.w700,
                                          //     color: const Color(0xFF363636),
                                          //   ),
                                          // ),
                                          // Text(
                                          //   '${resultPageParams.score} of ${resultPageParams.totalQuestions}',
                                          //   style: GoogleFonts.poppins(
                                          //     fontSize: 18,
                                          //     fontWeight: FontWeight.w500,
                                          //     color: const Color(0xFF717171),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 8,
                                  left: 53,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(32),
                                    ),
                                    child: FillingStarIcons(
                                      progress: (widget.resultPageParams.score /
                                              widget.resultPageParams
                                                  .totalQuestions) *
                                          100,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF18786A),
                              ),
                              onPressed: () {
                                widget.resultPageParams.examType ==
                                            ExamType.standardMock ||
                                        widget.resultPageParams.examType ==
                                            ExamType.downloadedMock
                                    ? goToMockAnalysis(
                                        widget.resultPageParams.mockType!)
                                    : widget.resultPageParams.questionMode ==
                                            QuestionMode.learning
                                        ? context.pop()
                                        : QuizQuestionPageRoute(
                                                courseId: widget
                                                    .resultPageParams.courseId!,
                                                quizId:
                                                    widget.resultPageParams.id,
                                                $extra: QuestionMode.analysis)
                                            .go(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 8,
                                ),
                                width: 40.w,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/search.png',
                                      width: 24,
                                    ),
                                    const SizedBox(width: 16),
                                    Text(
                                      widget.resultPageParams.questionMode ==
                                              QuestionMode.learning
                                          ? 'Go Back'
                                          : 'Analysis',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
