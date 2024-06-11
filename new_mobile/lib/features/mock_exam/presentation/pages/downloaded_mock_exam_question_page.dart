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

class DownloadedMockExamQuestionPageParams {
  final DownloadedUserMock downloadedUserMock;
  final QuestionMode questionMode;

  DownloadedMockExamQuestionPageParams({
    required this.downloadedUserMock,
    required this.questionMode,
  });
}

class DownloadedMockExamQuestionsPage extends StatefulWidget {
  final DownloadedMockExamQuestionPageParams mockExamQuestionPageParams;
  const DownloadedMockExamQuestionsPage({
    super.key,
    required this.mockExamQuestionPageParams,
  });

  @override
  State<DownloadedMockExamQuestionsPage> createState() =>
      _DownloadedMockExamQuestionsPageState();
}

class _DownloadedMockExamQuestionsPageState
    extends State<DownloadedMockExamQuestionsPage> {
  late List<String> userChoices;
  final PageController _pageController = PageController();
  late Timer _timer;
  late int _countDownDuration;

  int currentIndex = 0;
  int initialIndex = 0;
  @override
  void initState() {
    super.initState();
    _countDownDuration =
        widget.mockExamQuestionPageParams.questionMode == QuestionMode.quiz
            ? _countDownDuration = widget.mockExamQuestionPageParams
                    .downloadedUserMock.questions.length *
                60
            : _countDownDuration = 0;
    if (widget.mockExamQuestionPageParams.questionMode == QuestionMode.quiz) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
    }
    // context.read<MockQuestionBloc>().add(GetMockByIdEvent(
    //     id: widget.mockExamQuestionPageParams.downloadedUserMock.id,
    //     numberOfQuestions: widget
    //         .mockExamQuestionPageParams.downloadedUserMock.questions.length));
    userChoices = List.generate(
        widget.mockExamQuestionPageParams.downloadedUserMock.questions.length,
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
        // Todo: Upsert Mock Score
        BlocListener<OfflineMockUserScoreBloc, OfflineMockUserScoreState>(
          listener: (context, state) {
            if (state is UpsertMyMockScoreState) {
              if (state is OfflineMockUserScoreFailed &&
                  state.failure is RequestOverloadFailure) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(snackBar(state.failure!.errorMessage));
              } else if (state is OfflineMockUserScoreLoaded) {
                context.read<OfflineMockBloc>().add(FetchDownloadedMockEvent());
              }
            }
          },
        ),
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
              // Todo: Fetch Downloaded User Mocks
              // context
              //     .read<MyMocksBloc>()
              //     .add(const GetMyMocksEvent(isRefreshed: false));
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
                            // color: const Color(0xFF18786A),
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
        ),
        body: Stack(
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
                                widget.mockExamQuestionPageParams
                                    .downloadedUserMock.questions.length,
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
                        itemCount: widget.mockExamQuestionPageParams
                            .downloadedUserMock.questions.length,
                        controller: _pageController,
                        itemBuilder: (context, index) {
                          Question question = widget.mockExamQuestionPageParams
                              .downloadedUserMock.questions[index];
                          return QuestionSection(
                            examType: ExamType.standardMock,
                            examId: question.id,
                            isLiked: question.isLiked,
                            question: question,
                            currentIndex: index,
                            totalQuestions: widget.mockExamQuestionPageParams
                                .downloadedUserMock.questions.length,
                            userChoice: widget.mockExamQuestionPageParams
                                        .questionMode ==
                                    QuestionMode.analysis
                                ? widget
                                        .mockExamQuestionPageParams
                                        .downloadedUserMock
                                        .questions[index]
                                        .userAnswer ??
                                    'choice_E'
                                : userChoices[index],
                            onAnswerSelected: (selectedOption) {
                              setState(() {
                                userChoices[index] = selectedOption;
                              });
                            },
                            questionMode:
                                widget.mockExamQuestionPageParams.questionMode,
                            userAnswers: widget.mockExamQuestionPageParams
                                        .questionMode ==
                                    QuestionMode.analysis
                                ? widget.mockExamQuestionPageParams
                                    .downloadedUserMock.questions
                                    .map((mq) => mq.userAnswer ?? 'choice_E')
                                    .toList()
                                : userChoices,
                            goTo: goTo,
                            correctAnswers: List.generate(
                              widget.mockExamQuestionPageParams
                                  .downloadedUserMock.questions.length,
                              (index) =>
                                  widget
                                      .mockExamQuestionPageParams
                                      .downloadedUserMock
                                      .questions[index]
                                      .userAnswer ??
                                  'choice_E',
                            ),
                          );
                        },
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: QuestionBottomNavBar(
                          questionTitle: widget.mockExamQuestionPageParams
                              .downloadedUserMock.name,
                          index: currentIndex,
                          totalQuestions: widget.mockExamQuestionPageParams
                              .downloadedUserMock.questions.length,
                          goTo: goTo,
                          onSubmit: onSubmit,
                          onSaveScore: onSaveScore,
                          questionMode:
                              widget.mockExamQuestionPageParams.questionMode,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void onSubmit() {
    bool hasUnansweredQuestion = false;
    if (!hasUnansweredQuestion) {
      List<QuestionUserAnswer> questionUserAnswer = [];
      for (int i = 0; i < userChoices.length; i++) {
        questionUserAnswer.add(
          QuestionUserAnswer(
            questionId: widget
                .mockExamQuestionPageParams.downloadedUserMock.questions[i].id,
            userAnswer: userChoices[i],
          ),
        );
      }
      context.read<OfflineMockUserAnswerBloc>().add(
            OfflineMockUserAnswerEvent(
              mockId: widget.mockExamQuestionPageParams.downloadedUserMock.id,
              userAnswers: questionUserAnswer,
            ),
          );
    }
  }

  void onSaveScore() {
    int score = 0;
    for (int index = 0; index < userChoices.length; index++) {
      if (userChoices[index].toLowerCase() ==
          widget.mockExamQuestionPageParams.downloadedUserMock.questions[index]
              .answer
              .toLowerCase()) {
        score++;
      }
    }
    context.read<OfflineMockUserScoreBloc>().add(
          OfflineMockUserScoreEvent(
            mockId: widget.mockExamQuestionPageParams.downloadedUserMock.id,
            score: score,
            isCompleted: true,
          ),
        );
    // Todo: navigation to result page
    DownloadedMockResultPageRoute(
      $extra: ResultPageParams(
        id: widget.mockExamQuestionPageParams.downloadedUserMock.id,
        score: score,
        totalQuestions: widget
            .mockExamQuestionPageParams.downloadedUserMock.questions.length,
        examType: ExamType.downloadedMock,
        questionMode: widget.mockExamQuestionPageParams.questionMode,
        downloadedUserMock:
            widget.mockExamQuestionPageParams.downloadedUserMock,
        mockType: MockType.downloadedMock,
      ),
    ).go(context);
    // RecommendedMockResultPageRoute(
    //   $extra: ResultPageParams(
    //       score: score,
    //       totalQuestions: loadedMock.mockQuestions.length,
    //       id: loadedMock.id,
    //       examType: ExamType.standardMock,
    //       mockType: MockType.standardMocks,
    //       questionMode: widget.mockExamQuestionPageParams.questionMode),
    // ).go(context);
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
