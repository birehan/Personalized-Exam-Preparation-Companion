import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../core/core.dart';
import '../../../../core/utils/snack_bar.dart';
import '../../../../features/features.dart';
import '../../../feedback/presentation/widgets/flag_dialogue_box.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DailyQuestionPageParams extends Equatable {
  final DailyQuiz dailyQuiz;
  final QuestionMode questionMode;

  const DailyQuestionPageParams({
    required this.dailyQuiz,
    required this.questionMode,
  });

  @override
  List<Object?> get props => [
        dailyQuiz,
        questionMode,
      ];
}

class DailyQuestionPage extends StatefulWidget {
  const DailyQuestionPage({
    super.key,
    required this.dailyQuestionPageParams,
  });

  final DailyQuestionPageParams dailyQuestionPageParams;

  @override
  State<DailyQuestionPage> createState() => _DailyQuestionPageState();
}

class _DailyQuestionPageState extends State<DailyQuestionPage> {
  late List<String> userChoices;
  final PageController _pageController = PageController();

  late Timer _timer;
  late int _countDownDuration;

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.dailyQuestionPageParams.questionMode == QuestionMode.analysis) {
      userChoices = widget.dailyQuestionPageParams.dailyQuiz.dailyQuizQuestions
          .map((question) => question.userAnswer!)
          .toList();
    } else {
      userChoices = widget.dailyQuestionPageParams.dailyQuiz.dailyQuizQuestions
          .map((question) => 'choice_E')
          .toList();
    }

    widget.dailyQuestionPageParams.questionMode == QuestionMode.quiz
        ? _countDownDuration =
            widget.dailyQuestionPageParams.dailyQuiz.dailyQuizQuestions.length *
                60
        : _countDownDuration = 0;

    if (_countDownDuration < 0) {
      _countDownDuration = 0;
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countDownDuration > 0) {
        setState(() {
          _countDownDuration--;
        });
      } else {
        if (widget.dailyQuestionPageParams.questionMode == QuestionMode.quiz) {
          showPopupWhenCountdownEnds(context);
        }
        _timer.cancel();
      }
    });

    _pageController.addListener(() {
      setState(() {
        currentIndex = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void onSubmit() {
    _timer.cancel();
    // bool hasUnansweredQuestion = false;
    // for (int index = 0; index < userAnswers.length; index++) {
    //   if (userAnswers[index] == 'choice_E') {
    //     hasUnansweredQuestion = true;
    //     _showErrorSnackbar('Please answer all questions');
    //     goTo(index);
    //     break;
    //   }
    // }

    // if (!hasUnansweredQuestion) {
    final userAnswer = List.generate(
      userChoices.length,
      (index) => DailyQuizUserAnswer(
        questionId: widget
            .dailyQuestionPageParams.dailyQuiz.dailyQuizQuestions[index].id,
        userAnswer: userChoices[index],
      ),
    );

    final dailyQuizAnswer = DailyQuizAnswer(
      dailyQuizId: widget.dailyQuestionPageParams.dailyQuiz.id,
      userAnswer: userAnswer,
    );

    context.read<SubmitDailyQuizAnswerBloc>().add(
          SubmitDailyQuizAnswerEvent(
            dailyQuizAnswer: dailyQuizAnswer,
          ),
        );

    showPopupOnCompletingContest(context);
  }

  void showPopupOnCompletingContest(BuildContext originalContext) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            iconPadding: const EdgeInsets.only(right: 12, top: 10),
            icon: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.black),
                onPressed: () {
                  // onSubmit();
                  // onSaveScore();
                  context
                      .read<FetchDailyQuizForAnalysisBloc>()
                      .add(FetchDailyQuizForAnalysisInitialEvent());
                  context
                      .read<FetchDailyQuizBloc>()
                      .add(const FetchDailyQuizEvent());

                  context.read<FetchDailyQuizForAnalysisBloc>().add(
                        FetchDailyQuizForAnalysisByIdEvent(
                            id: widget.dailyQuestionPageParams.dailyQuiz.id),
                      );
                  context
                      .read<FetchDailyQuestBloc>()
                      .add(const FetchDailyQuestEvent());

                  //  context.read<PopupMenuBloc>().add(QuitExamEvent());
                  Navigator.of(context).pop();
                },
              ),
            ),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.task_alt, color: Color(0xFF0072FF), size: 48),
                // Image.asset('assets/images/time_machine.png'),
                const SizedBox(height: 12),
                Text(
                  // 'Completed successfully!',
                  AppLocalizations.of(originalContext)!.completed_successfully,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    color: const Color(0xFF0072FF),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 6),

                Align(
                    alignment: Alignment.center,
                    child: BlocConsumer<FetchDailyQuizForAnalysisBloc,
                        FetchDailyQuizForAnalysisState>(
                      builder: (context, state) {
                        // if (state is FetchDailyQuizForAnalysisLoading) {

                        //    return const  SizedBox(
                        //                 height: 15,
                        //                 width: 15,
                        //                 child:
                        //                     CircularProgressIndicator(
                        //                   color: Colors.black,
                        //                   strokeWidth: 1,
                        //                 ),
                        //               );
                        // }

                        return InkWell(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 1.h, horizontal: 4.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: const Color(0xFF0072FF),
                            ),
                            child: (state is FetchDailyQuizForAnalysisLoading)
                                ? const SizedBox(
                                    height: 10,
                                    width: 10,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 1,
                                    ),
                                  )
                                : Text(
                                    // 'Analysis',
                                    AppLocalizations.of(originalContext)!
                                        .analyis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                          onTap: () {
                            // onSubmit();
                            // onSaveScore();
                            _pageController.animateToPage(
                              0,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.ease,
                            );
                            context
                                .read<FetchDailyQuizForAnalysisBloc>()
                                .add(FetchDailyQuizForAnalysisInitialEvent());
                            context
                                .read<FetchDailyQuizBloc>()
                                .add(const FetchDailyQuizEvent());

                            context.read<FetchDailyQuizForAnalysisBloc>().add(
                                  FetchDailyQuizForAnalysisByIdEvent(
                                      id: widget.dailyQuestionPageParams
                                          .dailyQuiz.id),
                                );

                            //  context.read<PopupMenuBloc>().add(QuitExamEvent());
                            // if (!analysisPageLoading)
                            // Navigator.of(context).pop();
                          },
                        );
                      },
                      listener: (BuildContext context,
                          FetchDailyQuizForAnalysisState state) {
                        if (state is FetchDailyQuizForAnalysisFailed &&
                            state.failure is RequestOverloadFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              snackBar(state.failure.errorMessage));
                        } else if (state is FetchDailyQuizForAnalysisLoaded) {
                          Navigator.of(context).pop();

                          DailyQuizQuestionPageRoute(
                            $extra: DailyQuestionPageParams(
                              dailyQuiz: state.dailyQuiz,
                              questionMode: QuestionMode.analysis,
                            ),
                          ).go(context);
                        }
                      },
                    )),
              ],
            ),
            // content: Text(
            //   ' Are you sure you want to leave? Your unsaved changes may be lost.',
            //   style: GoogleFonts.poppins(),
            // ),
            // actions: [
            //   TextButton(
            //     onPressed: () {
            //       Navigator.of(context).pop();
            //     },
            //     child: Text(
            //       'Cancel',
            //       style: GoogleFonts.poppins(),
            //     ),
            //   ),
            //   TextButton(
            //     onPressed: () {
            //       onSubmit();
            //       context.read<PopupMenuBloc>().add(QuitExamEvent());
            //       Navigator.of(context).pop();
            //     },
            //     child: Text(
            //       'Quit',
            //       style: GoogleFonts.poppins(color: Colors.red),
            //     ),
            //   ),
            // ],
          );
        });
  }

  // void onSaveScore() {
  //   int score = 0;
  // for (int index = 0; index < userChoices.length; index++) {
  //   if (userChoices[index].toLowerCase() ==
  //       widget.questions[index].answer.toLowerCase()) {
  //     score++;
  //   }
  // }
  // widget.onSaveScore(score);
  // }

  // void onSaveScore() {
  //   bool hasUnansweredQuestion = false;
  //   int score = 0;
  //   for (int index = 0; index < userChoices.length; index++) {
  //     // if (userAnswers[index] == 'choice_E') {
  //     //   hasUnansweredQuestion = false;
  //     //   _showErrorSnackbar('Please answer all questions');
  //     //   break;
  //     // }
  //     if (userChoices[index] == widget.questions[index].answer) {
  //       score++;
  //     }
  //   }

  //     if (widget.examType == ExamType.standardMock) {
  //       context.read<MockExamBloc>().add(
  //             UpsertMockScoreEvent(
  //               mockId: widget.questionId,
  //               score: int.parse(
  //                   ((score / userChoices.length) * 100).toStringAsFixed(0)),
  //             ),
  //           );

  //       RecommendedMockResultPageRoute(
  //         $extra: ResultPageParams(
  //           score: score,
  //           totalQuestions: userChoices.length,
  //           id: widget.questionId,
  //           examType: ExamType.standardMock,
  //         ),
  //       ).go(context);
  //     } else {
  //       widget.onSaveScore();
  //     }
  //   }
  // }

  void showPopupWhenCountdownEnds(BuildContext originalContext) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(
            // 'Time Expired',
            AppLocalizations.of(originalContext)!.time_expired,
            style: GoogleFonts.poppins(color: Colors.red),
          ),
          content: Text(
            // 'You have run out of time to answer the question.',
            AppLocalizations.of(originalContext)!
                .you_have_run_out_of_time_to_answer_the_question,
            style: GoogleFonts.poppins(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                context
                    .read<FetchDailyQuizForAnalysisBloc>()
                    .add(FetchDailyQuizForAnalysisInitialEvent());
                context
                    .read<FetchDailyQuizBloc>()
                    .add(const FetchDailyQuizEvent());

                Navigator.of(context).pop();
              },
              child: Text(
                // 'OK',
                AppLocalizations.of(originalContext)!.ok,
                style: GoogleFonts.poppins(),
              ),
            ),
          ],
        );
      },
    );
  }

  void showPopupOnQuitButtonPressed(BuildContext originalContext) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(originalContext)!.confirmation_required,
            style: GoogleFonts.poppins(color: Colors.red),
          ),
          content: Text(
            AppLocalizations.of(originalContext)!
                .are_you_sure_you_want_to_leave_your_unsaved_changes_may_be_lost,
            style: GoogleFonts.poppins(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                AppLocalizations.of(originalContext)!.cancel,
                style: GoogleFonts.poppins(),
              ),
            ),
            TextButton(
              onPressed: () {
                context
                    .read<FetchDailyQuizForAnalysisBloc>()
                    .add(FetchDailyQuizForAnalysisInitialEvent());
                context
                    .read<FetchDailyQuizBloc>()
                    .add(const FetchDailyQuizEvent());
                context.read<PopupMenuBloc>().add(QuitExamEvent());
                Navigator.of(context).pop();
              },
              child: Text(
                AppLocalizations.of(originalContext)!.quit,
                style: GoogleFonts.poppins(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final hours =
        ((_countDownDuration ~/ 3600) % 24).toString().padLeft(2, '0');
    final minutes =
        ((_countDownDuration ~/ 60) % 60).toString().padLeft(2, '0');
    final seconds = (_countDownDuration % 60).toString().padLeft(2, '0');

    void goTo(int index) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<PopupMenuBloc, PopupMenuState>(
          listener: (context, state) {
            if (state is QuitExamState &&
                state.status == PopupMenuStatus.loaded) {
              context.pop();
            }
          },
        ),
        BlocListener<FeedbackBloc, FeedbackState>(
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
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check, color: Colors.white),
                      SizedBox(width: 8),
                      // Text('Thank you for your feedback 🙏',
                      Text(
                          '${AppLocalizations.of(context)!.thank_you_for_your_feedback} 🙏',
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
        )
      ],
      child: buildWidget(context, hours, minutes, seconds, goTo),
    );
  }

  Widget buildWidget(BuildContext context, String hours, String minutes,
      String seconds, Function(int) goTo) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        showPopupOnQuitButtonPressed(context);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: InkWell(
            onTap: () {
              showPopupOnQuitButtonPressed(context);
            },
            child: const Icon(
              Icons.arrow_back,
              color: Color(0xFF333333),
              size: 32,
            ),
          ),
          title:
              widget.dailyQuestionPageParams.questionMode == QuestionMode.quiz
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(),
                          Row(
                            children: [
                              const Icon(
                                Icons.alarm,
                                color: Color(0xFFFF6652),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '$hours:$minutes:$seconds',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFFF6652),
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              showPopupOnQuitButtonPressed(context);
                              // context
                              //     .read<PopupMenuBloc>()
                              //     .add(const GoToPageEvent());
                            },
                            child: Text(
                              // 'Quit',
                              AppLocalizations.of(context)!.quit,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.red,
                                // color: const Color(0xFF0072FF),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  : widget.dailyQuestionPageParams.questionMode ==
                          QuestionMode.analysis
                      ? Text(
                          // 'Daily Quiz Analysis',
                          AppLocalizations.of(context)!.daily_quiz_analysis,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF363636),
                          ),
                        )
                      : Container(),
        ),
        // floatingActionButton: FloatingOptions(
        //   hideChat:
        //       widget.dailyQuestionPageParams.questionMode == QuestionMode.quiz,
        //   chatCallback: () {
        // context
        //     .read<FetchDailyQuizForAnalysisBloc>()
        //     .add(FetchDailyQuizForAnalysisInitialEvent());
        // DailyQuizQuestionChatWithAIPageRoute(
        //   questionId: widget.dailyQuestionPageParams.dailyQuiz
        //       .dailyQuizQuestions[currentIndex].id,
        //   question:
        //       '${widget.dailyQuestionPageParams.dailyQuiz.dailyQuizQuestions[currentIndex].description}\nA) ${widget.dailyQuestionPageParams.dailyQuiz.dailyQuizQuestions[currentIndex].choiceA}\nB) ${widget.dailyQuestionPageParams.dailyQuiz.dailyQuizQuestions[currentIndex].choiceB}\nC) ${widget.dailyQuestionPageParams.dailyQuiz.dailyQuizQuestions[currentIndex].choiceC}\nD) ${widget.dailyQuestionPageParams.dailyQuiz.dailyQuizQuestions[currentIndex].choiceD}',
        //   $extra: widget.dailyQuestionPageParams,
        // ).go(context);
        //     // QuizChatWithAIPageRoute(
        //     //   courseId:
        //     //       'widget.dailyQuestionPageParams.dailyQuiz!.dailyQuizQuestions[currentIndex].courseId',
        //     //   quizId: widget.dailyQuestionPageParams.dailyQuiz!.id,
        //     //   questionId: widget.dailyQuestionPageParams.dailyQuiz!
        //     //       .dailyQuizQuestions[currentIndex].id,
        //     //   question:
        //     //       '${widget.dailyQuestionPageParams.dailyQuiz!.dailyQuizQuestions[currentIndex].description}\nA) ${widget.dailyQuestionPageParams.dailyQuiz!.dailyQuizQuestions[currentIndex].choiceA}\nB) ${widget.dailyQuestionPageParams.dailyQuiz!.dailyQuizQuestions[currentIndex].choiceB}\nC) ${widget.dailyQuestionPageParams.dailyQuiz!.dailyQuizQuestions[currentIndex].choiceC}\nD) ${widget.dailyQuestionPageParams.dailyQuiz!.dailyQuizQuestions[currentIndex].choiceD}',
        //     //   $extra: widget.dailyQuestionPageParams.questionMode,
        //     // ).go(context);
        //   },
        //   flagCallback: () {
        // showDialog(
        //   context: context,
        //   builder: (BuildContext context) {
        //     return FlagDialog(
        //       index: 0,
        //       id: widget.dailyQuestionPageParams.dailyQuiz!
        //           .dailyQuizQuestions[currentIndex].id,
        //       feedbackType: FeedbackType.questionFeedback,
        //     );
        //   },
        // );
        //   },
        // ),
        floatingActionButton:
            widget.dailyQuestionPageParams.questionMode == QuestionMode.quiz
                ? null
                : InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {
                      context
                          .read<FetchDailyQuizForAnalysisBloc>()
                          .add(FetchDailyQuizForAnalysisInitialEvent());
                      DailyQuizQuestionChatWithAIPageRoute(
                        questionId: widget.dailyQuestionPageParams.dailyQuiz
                            .dailyQuizQuestions[currentIndex].id,
                        question:
                            '${widget.dailyQuestionPageParams.dailyQuiz.dailyQuizQuestions[currentIndex].description}\nA) ${widget.dailyQuestionPageParams.dailyQuiz.dailyQuizQuestions[currentIndex].choiceA}\nB) ${widget.dailyQuestionPageParams.dailyQuiz.dailyQuizQuestions[currentIndex].choiceB}\nC) ${widget.dailyQuestionPageParams.dailyQuiz.dailyQuizQuestions[currentIndex].choiceC}\nD) ${widget.dailyQuestionPageParams.dailyQuiz.dailyQuizQuestions[currentIndex].choiceD}',
                        $extra: widget.dailyQuestionPageParams,
                      ).go(context);
                    },
                    child: const FloatingChatButton(),
                  ),
        floatingActionButtonLocation:
            const CustomFloatingActionButtonLocation(.8, .77),
        body: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: (currentIndex + 1) /
                            widget.dailyQuestionPageParams.dailyQuiz
                                .dailyQuizQuestions.length,
                        backgroundColor:
                            const Color.fromRGBO(24, 120, 106, 0.1),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFFFF6652),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Stack(
                children: [
                  PageView.builder(
                    itemCount: widget.dailyQuestionPageParams.dailyQuiz
                        .dailyQuizQuestions.length,
                    controller: _pageController,
                    itemBuilder: (context, index) {
                      //! here check if the item is dummy or real question

                      // if item is dummy
                      // if (widget.questions[index].description == 'dummyData') {
                      //   context.read<MockQuestionBloc>().add(LoadMockPageEvent(
                      //       id: widget.mockId!, pageNumber: index ~/ 10 + 1));
                      //   return const CustomProgressIndicator();
                      // }
                      // return progress indicator
                      // trigger event to load that page (the page is question number/10)
                      // go to that section

                      return DailyQuizQuestionSection(
                        examType: ExamType.quiz,
                        examId: widget.dailyQuestionPageParams.dailyQuiz
                            .dailyQuizQuestions[currentIndex].id,
                        isLiked: false,
                        question: widget.dailyQuestionPageParams.dailyQuiz
                            .dailyQuizQuestions[currentIndex],
                        currentIndex: index,
                        totalQuestions: widget.dailyQuestionPageParams.dailyQuiz
                            .dailyQuizQuestions.length,
                        userChoice: userChoices[index],
                        onAnswerSelected: (selectedOption) {
                          setState(() {
                            userChoices[index] = selectedOption;
                          });
                        },
                        questionMode:
                            widget.dailyQuestionPageParams.questionMode,
                        userAnswers: userChoices,
                        goTo: goTo,
                        correctAnswers: List.generate(
                          widget.dailyQuestionPageParams.dailyQuiz
                              .dailyQuizQuestions.length,
                          (index) => 'widget.questions[index].answer',
                        ),
                        params: widget.dailyQuestionPageParams,
                      );
                    },
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: QuestionBottomNavBar(
                      questionTitle: '',
                      showQuestionTitle: false,
                      index: currentIndex,
                      totalQuestions: widget.dailyQuestionPageParams.dailyQuiz
                          .dailyQuizQuestions.length,
                      goTo: goTo,
                      onSubmit: onSubmit,
                      onSaveScore: () {},
                      questionMode: widget.dailyQuestionPageParams.questionMode,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
