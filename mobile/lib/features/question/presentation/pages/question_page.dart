import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/core.dart';
import '../../../features.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class QuestionsPage extends StatefulWidget {
  final String questionId;
  final String questionTitle;
  final List<Question> questions;
  final List<UserAnswer> userAnswers;
  final QuestionMode questionMode;
  final ExamType examType;
  final Function(int) onSaveScore;
  final MockType? mockType;
  final String? courseName;
  final String? courseImage;
  final bool? isStandard;
  final String? mockId;

  const QuestionsPage({
    super.key,
    required this.questionId,
    required this.questionTitle,
    required this.questions,
    required this.userAnswers,
    required this.questionMode,
    required this.examType,
    required this.onSaveScore,
    this.mockType,
    this.courseName,
    this.courseImage,
    this.isStandard,
    this.mockId,
  });

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  late List<String> userChoices;
  final PageController _pageController = PageController();

  late Timer _timer;
  late int _countDownDuration;

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.questionMode == QuestionMode.analysis) {
      userChoices = widget.userAnswers
          .map((userAnswer) => userAnswer.userAnswer)
          .toList();
    } else {
      userChoices = widget.questions.map((question) => 'choice_E').toList();
    }

    widget.questionMode == QuestionMode.quiz
        ? _countDownDuration = widget.questions.length * 60
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
        if (widget.questionMode == QuestionMode.quiz) {
          showPopupWhenCountdownEnds();
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
    // _timer.cancel();
    bool hasUnansweredQuestion = false;
    // for (int index = 0; index < userAnswers.length; index++) {
    //   if (userAnswers[index] == 'choice_E') {
    //     hasUnansweredQuestion = true;
    //     _showErrorSnackbar('Please answer all questions');
    //     goTo(index);
    //     break;
    //   }
    // }

    if (!hasUnansweredQuestion) {
      final questionUserAnswers = List.generate(
        userChoices.length,
        (index) => QuestionUserAnswer(
          questionId: widget.userAnswers[index].questionId,
          userAnswer: userChoices[index],
        ),
      );

      context.read<QuestionBloc>().add(
            QuestionAnswerEvent(
              questionUserAnswers: questionUserAnswers,
            ),
          );
    }
  }

  void onSaveScore() {
    int score = 0;
    for (int index = 0; index < userChoices.length; index++) {
      if (userChoices[index].toLowerCase() ==
          widget.questions[index].answer.toLowerCase()) {
        score++;
      }
    }
    widget.onSaveScore(score);
  }

  void showPopupWhenCountdownEnds() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Time Expired', //! this has to be changed
            style: GoogleFonts.poppins(color: Colors.red),
          ),
          content: Text(
            'You have run out of time to answer the question.', //! this has to be changed
            style: GoogleFonts.poppins(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                onSubmit();
                onSaveScore();
                // context.read<PopupMenuBloc>().add(const GoToPageEvent());
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
                style: GoogleFonts.poppins(),
              ),
            ),
          ],
        );
      },
    );
  }

  void showPopupOnQuitButtonPressed() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Confirmation Required', //! this has to be changed
            style: GoogleFonts.poppins(color: Colors.red),
          ),
          content: Text(
            ' Are you sure you want to leave? Your unsaved changes may be lost.', //! this has to be changed
            style: GoogleFonts.poppins(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // onSubmit();
                // onSaveScore();
                // context.read<PopupMenuBloc>().add(QuitExamEvent());
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel', //! this has to be changed
                style: GoogleFonts.poppins(),
              ),
            ),
            TextButton(
              onPressed: () {
                onSubmit();
                // onSaveScore();
                context.read<PopupMenuBloc>().add(QuitExamEvent());
                Navigator.of(context).pop();
              },
              child: Text(
                'Quit',
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
        BlocListener<UpsertMockScoreBloc, UpsertMockScoreState>(
          listener: (context, state) {
            if (state is UpsertMyMockScoreState &&
                state.status == MockExamStatus.loaded) {
              context
                  .read<MyMocksBloc>()
                  .add(const GetMyMocksEvent(isRefreshed: false));
            }
          },
        ),
        BlocListener<QuizQuestionBloc, QuizQuestionState>(
          listener: (context, state) {
            if (state is SaveQuizScoreState &&
                state.status == QuizQuestionStatus.loaded) {
              context.read<QuizBloc>().add(const GetUserQuizEvent(
                    courseId: '',
                    isRefreshed: true,
                  ));
            }
          },
        ),
        BlocListener<MockQuestionBloc, MockQuestionState>(
          listener: (context, state) {
            if (state is GetMockExamByIdState &&
                state.status == MockQuestionStatus.loaded) {
              goTo(currentIndex);
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
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                          'Thank you for your feedback 🙏', //! this has to be changed
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
      canPop: widget.questionMode == QuestionMode.quiz ? false : true,
      onPopInvoked: (didPop) {
        if (widget.questionMode == QuestionMode.quiz) {
          showPopupOnQuitButtonPressed();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: InkWell(
            onTap: () {
              context
                  .read<MyMocksBloc>()
                  .add(const GetMyMocksEvent(isRefreshed: false));
              if (widget.questionMode == QuestionMode.quiz) {
                showPopupOnQuitButtonPressed();
              } else {
                context.pop();
              }
            },
            child: const Icon(
              Icons.arrow_back,
              color: Color(0xFF333333),
              size: 32,
            ),
          ),
          title: widget.questionMode == QuestionMode.quiz
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
                          showPopupOnQuitButtonPressed();
                          // context
                          //     .read<PopupMenuBloc>()
                          //     .add(const GoToPageEvent());
                        },
                        child: Text(
                          'Quit',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                            // color: const Color(0xFF18786A),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : widget.questionMode == QuestionMode.analysis
                  ? Text(
                      widget.examType == ExamType.quiz
                          ? 'Quiz Analysis'
                          : 'Mock Analysis',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF363636),
                      ),
                    )
                  : Text(
                      AppLocalizations.of(context)!.learning_mode,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF363636),
                      ),
                    ),
        ),
        // floatingActionButton: FloatingOptions(
        //   hideChat: widget.questionMode == QuestionMode.quiz,
        //   chatCallback: () {
        // if (widget.examType == ExamType.quiz) {
        //   QuizChatWithAIPageRoute(
        //     courseId: widget.questions[currentIndex].courseId,
        //     quizId: widget.questionId,
        //     questionId: widget.questions[currentIndex].id,
        //     question:
        //         '${widget.questions[currentIndex].description}\nA) ${widget.questions[currentIndex].choiceA}\nB) ${widget.questions[currentIndex].choiceB}\nC) ${widget.questions[currentIndex].choiceC}\nD) ${widget.questions[currentIndex].choiceD}',
        //     $extra: widget.questionMode,
        //   ).go(context);
        // }
        //   },
        //   flagCallback: () {
        // showDialog(
        //   context: context,
        //   builder: (BuildContext context) {
        //     return FlagDialog(
        //       index: 0,
        //       id: widget.questions[currentIndex].id,
        //       feedbackType: FeedbackType.questionFeedback,
        //     );
        //   },
        // );
        //   },
        // ),
        floatingActionButton: widget.questionMode == QuestionMode.quiz
            ? null
            : InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  if (widget.examType == ExamType.quiz) {
                    QuizChatWithAIPageRoute(
                      courseId: widget.questions[currentIndex].courseId,
                      quizId: widget.questionId,
                      questionId: widget.questions[currentIndex].id,
                      question:
                          '${widget.questions[currentIndex].description}\nA) ${widget.questions[currentIndex].choiceA}\nB) ${widget.questions[currentIndex].choiceB}\nC) ${widget.questions[currentIndex].choiceC}\nD) ${widget.questions[currentIndex].choiceD}',
                      $extra: widget.questionMode,
                    ).go(context);
                  }
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
                        value: (currentIndex + 1) / widget.questions.length,
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
                    itemCount: widget.questions.length,
                    controller: _pageController,
                    itemBuilder: (context, index) {
                      return QuestionSection(
                        courseName: widget.courseName,
                        courseImage: widget.courseImage,
                        examType: widget.examType,
                        mockType: widget.mockType,
                        examId: widget.questionId,
                        isLiked: widget.questions[index].isLiked,
                        question: widget.questions[index],
                        currentIndex: index,
                        totalQuestions: widget.questions.length,
                        userChoice: userChoices[index],
                        onAnswerSelected: (selectedOption) {
                          setState(() {
                            userChoices[index] = selectedOption;
                          });
                        },
                        questionMode: widget.questionMode,
                        userAnswers: userChoices,
                        goTo: goTo,
                        correctAnswers: List.generate(
                          widget.questions.length,
                          (index) => widget.questions[index].answer,
                        ),
                        isStandard: widget.isStandard,
                      );
                    },
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: QuestionBottomNavBar(
                      questionTitle: widget.questionTitle,
                      index: currentIndex,
                      totalQuestions: widget.questions.length,
                      goTo: goTo,
                      onSubmit: onSubmit,
                      onSaveScore: onSaveScore,
                      questionMode: widget.questionMode,
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
