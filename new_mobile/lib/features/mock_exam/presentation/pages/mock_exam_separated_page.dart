import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';
import 'package:prep_genie/core/utils/create_links.dart';
import 'package:prep_genie/core/widgets/share.dart';

import '../../../../core/core.dart';
import '../../../../core/utils/snack_bar.dart';
import '../../../../core/widgets/questions_shimmer.dart';
import '../../../features.dart';
import '../../../feedback/presentation/widgets/flag_dialogue_box.dart';

class MockExamQuestionPageParams {
  final int questionNumber;
  final String mockId;
  final QuestionMode questionMode;
  final MockType mockType;
  final String? courseImage;
  final String? courseName;
  final bool? isStandard;
  final bool completed;

  MockExamQuestionPageParams({
    required this.questionNumber,
    required this.mockId,
    required this.questionMode,
    required this.mockType,
    this.courseImage,
    this.courseName,
    this.isStandard,
    required this.completed,
  });
}

class MockExamQuestionsPage extends StatefulWidget {
  final MockExamQuestionPageParams mockExamQuestionPageParams;
  const MockExamQuestionsPage({
    super.key,
    required this.mockExamQuestionPageParams,
  });

  @override
  State<MockExamQuestionsPage> createState() => _MockExamQuestionsPageState();
}

class _MockExamQuestionsPageState extends State<MockExamQuestionsPage> {
  late List<String> userChoices;
  final PageController _pageController = PageController();
  Mock loadedMock =
      const Mock(id: 'id', name: 'name', userId: 'userId', mockQuestions: []);
  late Timer _timer;
  late int _countDownDuration;

  int currentIndex = 0;
  int initialIndex = 0;
  @override
  void initState() {
    super.initState();
    context.read<UserMockBloc>().add(AddMockToUserMockEvent(
        mockId: widget.mockExamQuestionPageParams.mockId));
    _countDownDuration =
        widget.mockExamQuestionPageParams.questionMode == QuestionMode.quiz
            ? _countDownDuration =
                widget.mockExamQuestionPageParams.questionNumber * 60
            : _countDownDuration = 0;
    context.read<MockQuestionBloc>().add(GetMockByIdEvent(
        id: widget.mockExamQuestionPageParams.mockId,
        numberOfQuestions: widget.mockExamQuestionPageParams.questionNumber));
    userChoices = List.generate(
        widget.mockExamQuestionPageParams.questionNumber,
        (index) => 'choice_E');

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

  @override
  Widget build(BuildContext context) {
    final hours =
        ((_countDownDuration ~/ 3600) % 24).toString().padLeft(2, '0');
    final minutes =
        ((_countDownDuration ~/ 60) % 60).toString().padLeft(2, '0');
    final seconds = (_countDownDuration % 60).toString().padLeft(2, '0');

    void goTo(int index) {
      _pageController.jumpToPage(index);
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
            if (state is UpsertMyMockScoreState) {
              if (state.status == MockExamStatus.error &&
                  state.failure is RequestOverloadFailure) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(snackBar(state.failure!.errorMessage));
              } else if (state.status == MockExamStatus.loaded) {
                context
                    .read<MyMocksBloc>()
                    .add(const GetMyMocksEvent(isRefreshed: false));
              }
            }
          },
        ),
        BlocListener<MockQuestionBloc, MockQuestionState>(
          listener: (context, state) {
            if (state is GetMockExamByIdState) {
              if (state.status == MockQuestionStatus.error &&
                  state.failure is RequestOverloadFailure) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(snackBar(state.failure!.errorMessage));
              } else if (state.status == MockQuestionStatus.loaded) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Future.delayed(Duration.zero, () {
                    goTo(currentIndex);
                    _timer =
                        Timer.periodic(const Duration(seconds: 1), (timer) {
                      if (_countDownDuration > 0) {
                        setState(() {
                          _countDownDuration--;
                        });
                      } else {
                        if (widget.mockExamQuestionPageParams.questionMode ==
                            QuestionMode.quiz) {
                          showPopupWhenCountdownEnds();
                        }
                        _timer.cancel();
                      }
                    });
                    setState(() {
                      loadedMock = state.mock!;
                    });
                  });
                });
              }
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
      canPop:
          widget.mockExamQuestionPageParams.questionMode == QuestionMode.quiz
              ? false
              : true,
      onPopInvoked: (didPop) {
        if (widget.mockExamQuestionPageParams.questionMode ==
            QuestionMode.quiz) {
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
              if (widget.mockExamQuestionPageParams.questionMode ==
                  QuestionMode.quiz) {
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
          title: widget.mockExamQuestionPageParams.questionMode ==
                  QuestionMode.quiz
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
                        },
                        child: Text(
                          'Quit',
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
              : widget.mockExamQuestionPageParams.questionMode ==
                      QuestionMode.analysis
                  ? Text(
                      'Mock Analysis', //! this has to be changed
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
          // actions: [
          //   if (loadedMock.id != 'id')
          //     ShareButton(
          //       route:
          //           '/shared-question-page/${loadedMock.mockQuestions[currentIndex].question.id}',
          //       subject: 'SkillBridge question',
          //     ),
          // ],
        ),
        body: BlocConsumer<MockQuestionBloc, MockQuestionState>(
          listener: (context, state) {
            if (state is GetMockExamByIdState &&
                state.status == MockQuestionStatus.error) {
              if (state.failure is RequestOverloadFailure) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(snackBar(state.failure!.errorMessage));
              }
            }
            if (state is GetMockExamByIdState &&
                state.status == MockQuestionStatus.loaded &&
                userChoices == null) {
              setState(() {
                userChoices = state.mock!.mockQuestions
                    .map((mock) => mock.userAnswer.userAnswer)
                    .toList();
              });
            }
          },
          builder: (context, state) {
            if (state is GetMockExamByIdState &&
                state.status == MockQuestionStatus.error) {
              return const Center(
                child: Text('Error Loading Question'),
              );
            } else if (state is GetMockExamByIdState &&
                state.status == MockQuestionStatus.loading) {
              return Scaffold(
                body: QuestionShimmerCard(),
              );
            } else if (state is GetMockExamByIdState &&
                state.status == MockQuestionStatus.loaded) {
              Mock mock = state.mock!;

              return Stack(
                children: [
                  Column(
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
                                      mock.mockQuestions.length,
                                  backgroundColor:
                                      const Color.fromRGBO(24, 120, 106, 0.1),
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
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
                              itemCount: mock.mockQuestions.length,
                              controller: _pageController,
                              itemBuilder: (context, index) {
                                // if item is dummy
                                if (mock.mockQuestions[index].question
                                        .description ==
                                    'dummyData') {
                                  context.read<MockQuestionBloc>().add(
                                      LoadMockPageEvent(
                                          id: mock.id,
                                          pageNumber: index ~/ 10 + 1));

                                  _timer.cancel();
                                  return const CustomProgressIndicator();
                                }

                                Question question =
                                    mock.mockQuestions[index].question;
                                return QuestionSection(
                                  courseName: widget
                                      .mockExamQuestionPageParams.courseName,
                                  courseImage: widget
                                      .mockExamQuestionPageParams.courseImage,
                                  examType: ExamType.standardMock,
                                  mockType: widget
                                      .mockExamQuestionPageParams.mockType,
                                  examId: question.id,
                                  isLiked: question.isLiked,
                                  question: question,
                                  currentIndex: index,
                                  totalQuestions: mock.mockQuestions.length,
                                  userChoice: widget.mockExamQuestionPageParams
                                              .questionMode ==
                                          QuestionMode.analysis
                                      ? mock.mockQuestions[index].userAnswer
                                          .userAnswer
                                      : userChoices[index],
                                  onAnswerSelected: (selectedOption) {
                                    setState(() {
                                      userChoices[index] = selectedOption;
                                    });
                                  },
                                  questionMode: widget
                                      .mockExamQuestionPageParams.questionMode,
                                  userAnswers: widget.mockExamQuestionPageParams
                                              .questionMode ==
                                          QuestionMode.analysis
                                      ? mock.mockQuestions
                                          .map((mq) => mq.userAnswer.userAnswer)
                                          .toList()
                                      : userChoices,
                                  goTo: goTo,
                                  correctAnswers: List.generate(
                                    mock.mockQuestions.length,
                                    (index) => mock.mockQuestions[index]
                                        .userAnswer.userAnswer,
                                  ),
                                  isStandard: widget
                                      .mockExamQuestionPageParams.isStandard,
                                );
                              },
                            ),
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: QuestionBottomNavBar(
                                questionTitle: mock.name,
                                index: currentIndex,
                                totalQuestions: mock.mockQuestions.length,
                                goTo: goTo,
                                onSubmit: onSubmit,
                                onSaveScore: onSaveScore,
                                questionMode: widget
                                    .mockExamQuestionPageParams.questionMode,
                              ),
                            ),
                            if (widget
                                    .mockExamQuestionPageParams.questionMode !=
                                QuestionMode.quiz)
                              Positioned(
                                right: 10.w,
                                bottom: 15.h,
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    if (widget.mockExamQuestionPageParams
                                            .courseImage !=
                                        null) {
                                      MocksChatWithApiRoute(
                                        mockId: mock.id,
                                        courseImage: widget
                                                .mockExamQuestionPageParams
                                                .courseImage ??
                                            '',
                                        courseName: widget
                                                .mockExamQuestionPageParams
                                                .courseName ??
                                            '',
                                        isStandard: widget
                                                .mockExamQuestionPageParams
                                                .isStandard ??
                                            false,
                                        questionId: mock
                                            .mockQuestions[currentIndex]
                                            .question
                                            .id,
                                        $extra:
                                            widget.mockExamQuestionPageParams,
                                        question:
                                            '${mock.mockQuestions[currentIndex].question.description}\nA) ${mock.mockQuestions[currentIndex].question.choiceA}\nB) ${mock.mockQuestions[currentIndex].question.choiceB}\nC) ${mock.mockQuestions[currentIndex].question.choiceC}\nD) ${mock.mockQuestions[currentIndex].question.choiceD}',
                                      ).go(context);
                                    } else {
                                      UserMocksChatWithApiRoute(
                                        mockId: mock.id,
                                        $extra:
                                            widget.mockExamQuestionPageParams,
                                        questionId: mock
                                            .mockQuestions[currentIndex]
                                            .question
                                            .id,
                                        question:
                                            '${mock.mockQuestions[currentIndex].question.description}\nA) ${mock.mockQuestions[currentIndex].question.choiceA}\nB) ${mock.mockQuestions[currentIndex].question.choiceB}\nC) ${mock.mockQuestions[currentIndex].question.choiceC}\nD) ${mock.mockQuestions[currentIndex].question.choiceD}',
                                      ).go(context);
                                    }
                                  },
                                  child: const FloatingChatButton(),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  void onSubmit() {
    bool hasUnansweredQuestion = false;
    if (!hasUnansweredQuestion) {
      List<QuestionUserAnswer> questionUserAnswer = [];
      // taking only valid questions from the list
      for (int i = 0; i < userChoices.length; i++) {
        if (loadedMock.mockQuestions[i].question.id != 'dummyData') {
          questionUserAnswer.add(QuestionUserAnswer(
            questionId: loadedMock.mockQuestions[i].userAnswer.questionId,
            userAnswer: userChoices[i],
          ));
        }
      }
      context.read<QuestionBloc>().add(
            QuestionAnswerEvent(
              questionUserAnswers: questionUserAnswer,
            ),
          );
    }
  }

  void onSaveScore() {
    int score = 0;
    for (int index = 0; index < userChoices.length; index++) {
      if (userChoices[index].toLowerCase() ==
          loadedMock.mockQuestions[index].question.answer.toLowerCase()) {
        score++;
      }
    }
    context.read<UpsertMockScoreBloc>().add(
          UpsertMyMockScoreEvent(
            mockId: loadedMock.id,
            score: score,
          ),
        );
    RecommendedMockResultPageRoute(
      $extra: ResultPageParams(
          score: score,
          totalQuestions: loadedMock.mockQuestions.length,
          id: loadedMock.id,
          examType: ExamType.standardMock,
          mockType: MockType.standardMocks,
          questionMode: widget.mockExamQuestionPageParams.questionMode),
    ).go(context);
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
                'Ok', //! this has to be changed
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
}
