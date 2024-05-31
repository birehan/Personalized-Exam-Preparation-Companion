import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skill_bridge_mobile/features/contest/presentation/bloc/contest_ranking_bloc/contest_ranking_bloc.dart';

import '../../../../core/core.dart';
import '../../../../core/utils/snack_bar.dart';
import '../../../../core/widgets/questions_shimmer.dart';
import '../../../features.dart';
import '../../../feedback/presentation/widgets/flag_dialogue_box.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ContestQuestionByCategoryPageParams {
  final Duration timeLeft;
  final List<ContestCategory> contestCategories;
  final String categoryId;
  final String contestId;
  final Function(String) updateSubmittedCategories;
  final bool hasEnded;

  ContestQuestionByCategoryPageParams({
    required this.categoryId,
    required this.timeLeft,
    required this.contestCategories,
    required this.contestId,
    required this.updateSubmittedCategories,
    required this.hasEnded,
  });
}

class ContestQuestionsByCategoryPage extends StatefulWidget {
  const ContestQuestionsByCategoryPage({
    super.key,
    required this.contestQuestionByCategoryPageparams,
  });

  final ContestQuestionByCategoryPageParams contestQuestionByCategoryPageparams;

  @override
  State<ContestQuestionsByCategoryPage> createState() =>
      _ContestQuestionsByCategoryPageState();
}

class _ContestQuestionsByCategoryPageState
    extends State<ContestQuestionsByCategoryPage>
    with TickerProviderStateMixin {
  Map<String, List<String>> userChoices = {};
  final PageController _pageController = PageController();
  late final TabController _tabController;
  int _tabIndex = 0;

  late Timer _timer;
  late int _countDownDuration;

  late String selectedCategory;
  Set<String> submittedCategories = {};

  int currentIndex = 0;
  int initialIndex = 0;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _tabIndex = _tabController.index;
      });
    });

    selectedCategory = widget.contestQuestionByCategoryPageparams.categoryId;

    _countDownDuration =
        widget.contestQuestionByCategoryPageparams.timeLeft.inSeconds;

    for (var contestCategory
        in widget.contestQuestionByCategoryPageparams.contestCategories) {
      if (!widget.contestQuestionByCategoryPageparams.hasEnded) {
        userChoices[contestCategory.categoryId] = List.generate(
            contestCategory.numberOfQuestion, (index) => 'choice_E');
      }

      if (!widget.contestQuestionByCategoryPageparams.hasEnded &&
          contestCategory.isSubmitted) {
        submittedCategories.add(contestCategory.categoryId);
      }
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countDownDuration > 0) {
        setState(() {
          _countDownDuration--;
        });
      } else {
        if (!widget.contestQuestionByCategoryPageparams.hasEnded) {
          showPopupWhenCountdownEnds(
            context: context,
            onPressed: () {
              context.read<ContestDetailBloc>().add(GetContestdetailEvent(
                  contestId:
                      widget.contestQuestionByCategoryPageparams.contestId));
              context.read<ContestRankingBloc>().add(GetContestRankingEvent(
                  contestId:
                      widget.contestQuestionByCategoryPageparams.contestId));
              context.read<PopupMenuBloc>().add(TimesUpEvent());
            },
          );
        }
        _timer.cancel();
      }
    });

    _pageController.addListener(() {
      setState(() {
        currentIndex = _pageController.page?.round() ?? 0;
      });
    });

    if (!widget.contestQuestionByCategoryPageparams.hasEnded) {
      context.read<FetchContestQuestionsByCategoryBloc>().add(
            FetchContestQuestionsByCategoryEvent(
              categoryId: selectedCategory,
            ),
          );
    } else {
      context.read<FetchContestAnalysisByCategoryBloc>().add(
            FetchContestAnalysisByCategoryEvent(
              categoryId: selectedCategory,
            ),
          );
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void onSubmit() {
    List<ContestAnswer> userAnswers = [];
    final categoryAnswers = userChoices[selectedCategory]!;

    List<String> questionIds = [];
    final state = context.read<FetchContestQuestionsByCategoryBloc>().state;
    if (state is FetchContestQuestionsByCategoryLoaded) {
      for (int i = 0; i < state.contestQuestions.length; i++) {
        questionIds.add(state.contestQuestions[i].id);
      }
    }

    for (int i = 0; i < categoryAnswers.length; i++) {
      userAnswers.add(
        ContestAnswer(
          contestQuestionId: questionIds[i],
          userAnswer: categoryAnswers[i],
        ),
      );
    }

    final contestUserAnswer = ContestUserAnswer(
      contestCategoryId: selectedCategory,
      userAnswers: userAnswers,
    );

    context.read<ContestSubmitUserAnswerBloc>().add(
          ContestSubmitUserAnswerEvent(
            contestUserAnswer: contestUserAnswer,
          ),
        );

    submittedCategories.add(selectedCategory);

    for (int i = 0;
        i < widget.contestQuestionByCategoryPageparams.contestCategories.length;
        i++) {
      if (!submittedCategories.contains(widget
          .contestQuestionByCategoryPageparams
          .contestCategories[i]
          .categoryId)) {
        changeCategory(widget.contestQuestionByCategoryPageparams
            .contestCategories[i].categoryId);

        context.read<FetchContestQuestionsByCategoryBloc>().add(
              FetchContestQuestionsByCategoryEvent(
                categoryId: widget.contestQuestionByCategoryPageparams
                    .contestCategories[i].categoryId,
              ),
            );
        break;
      }

      if (i ==
          widget.contestQuestionByCategoryPageparams.contestCategories.length -
              1) {
        showPopupOnCompletingContest(
          context: context,
          onCompleted: () {
            context.read<ContestDetailBloc>().add(GetContestdetailEvent(
                contestId:
                    widget.contestQuestionByCategoryPageparams.contestId));
            context.read<PopupMenuBloc>().add(QuitExamEvent());
          },
          title: AppLocalizations.of(context)!.completed_successfully,
          // title: "Completed successfully!",
          isSubmitted: true,
        );
      }
    }
    currentIndex = 0;
  }

  void changeCategory(String categoryId) {
    setState(() {
      selectedCategory = categoryId;
    });
  }

  void updateSubmittedCategories(String categoryId) {
    widget.contestQuestionByCategoryPageparams
        .updateSubmittedCategories(categoryId);
    if (!widget.contestQuestionByCategoryPageparams.hasEnded) {
      setState(() {
        submittedCategories.add(categoryId);

        if (submittedCategories.length ==
            widget
                .contestQuestionByCategoryPageparams.contestCategories.length) {
          showPopupOnCompletingContest(
            context: context,
            onCompleted: () {
              context.read<ContestDetailBloc>().add(GetContestdetailEvent(
                  contestId:
                      widget.contestQuestionByCategoryPageparams.contestId));
              context.read<PopupMenuBloc>().add(QuitExamEvent());
            },
            title: AppLocalizations.of(context)!.completed_successfully,
            // title: "Completed successfully!",
            isSubmitted: true,
          );
        }
      });
    } else {
      setState(() {
        submittedCategories.add(categoryId);
        for (int i = 0;
            i <
                widget.contestQuestionByCategoryPageparams.contestCategories
                    .length;
            i++) {
          if (!submittedCategories.contains(widget
              .contestQuestionByCategoryPageparams
              .contestCategories[i]
              .categoryId)) {
            changeCategory(widget.contestQuestionByCategoryPageparams
                .contestCategories[i].categoryId);

            context.read<FetchContestAnalysisByCategoryBloc>().add(
                  FetchContestAnalysisByCategoryEvent(
                    categoryId: widget.contestQuestionByCategoryPageparams
                        .contestCategories[i].categoryId,
                  ),
                );
            break;
          }

          if (i ==
              widget.contestQuestionByCategoryPageparams.contestCategories
                      .length -
                  1) {
            showPopupOnCompletingContest(
              context: context,
              onCompleted: () {
                context.read<ContestDetailBloc>().add(GetContestdetailEvent(
                    contestId:
                        widget.contestQuestionByCategoryPageparams.contestId));
                context.read<PopupMenuBloc>().add(QuitExamEvent());
              },
              title: AppLocalizations.of(context)!.completed_successfully,
              // title: "Completed successfully!",
              isSubmitted: true,
            );
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int pageIndex = 0;

    final hours =
        ((_countDownDuration ~/ 3600) % 24).toString().padLeft(2, '0');
    final minutes =
        ((_countDownDuration ~/ 60) % 60).toString().padLeft(2, '0');
    final seconds = (_countDownDuration % 60).toString().padLeft(2, '0');

    void goTo(int index) {
      _pageController.jumpToPage(index);
      setState(() {
        pageIndex = index;
      });
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<FetchContestAnalysisByCategoryBloc,
            FetchContestAnalysisByCategoryState>(
          listener: (_, state) {
            if (state is FetchContestAnalysisByCategoryFailed) {
              if (state.failure is RequestOverloadFailure) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(snackBar(state.errorMessage));
              }
            }
          },
        ),
        BlocListener<PopupMenuBloc, PopupMenuState>(
          listener: (_, state) {
            if (state is QuitExamState &&
                state.status == PopupMenuStatus.loaded) {
              context.pop();
            } else if (state is TimesUpState &&
                state.status == PopupMenuStatus.loaded) {
              context.pop();
            }
          },
        ),
        BlocListener<FeedbackBloc, FeedbackState>(
          listener: (_, state) {
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
                      Text('${AppLocalizations.of(context)!.thank_you_for_your_feedback} 🙏',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                duration: const Duration(seconds: 3),
                behavior: SnackBarBehavior.floating,
              );

              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else if (state is FeedbackSubmisionFailedState &&
                state.failure is RequestOverloadFailure) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(snackBar(state.errorMessage));
            }
          },
        )
      ],
      child: buildWidget(context, hours, minutes, seconds, goTo, currentIndex),
    );
  }

  Widget buildWidget(
    BuildContext context,
    String hours,
    String minutes,
    String seconds,
    Function(int) goTo,
    int pageIndex,
  ) {
    return PopScope(
      canPop: widget.contestQuestionByCategoryPageparams.hasEnded,
      onPopInvoked: (didPop) {
        if (!widget.contestQuestionByCategoryPageparams.hasEnded) {
          showPopupOnQuitButtonPressed(
            context: context,
            onQuitPressed: () {
              context.read<ContestDetailBloc>().add(GetContestdetailEvent(
                  contestId:
                      widget.contestQuestionByCategoryPageparams.contestId));
              context.read<PopupMenuBloc>().add(QuitExamEvent());
            },
          );
        }
      },
      child: widget.contestQuestionByCategoryPageparams.hasEnded
          ? BlocBuilder<FetchContestAnalysisByCategoryBloc,
              FetchContestAnalysisByCategoryState>(
              builder: (_, state) {
                if (state is FetchContestAnalysisByCategoryFailed) {
                  return Scaffold(
                    body: Center(
                      child: Text(AppLocalizations.of(context)!.error_loading_question),
                    ),
                  );
                } else if (state is FetchContestAnalysisByCategoryLoading) {
                  return Scaffold(
                    body: QuestionShimmerCard(),
                  );
                } else if (state is FetchContestAnalysisByCategoryLoaded) {
                  List<ContestQuestion> contestQuestions =
                      state.contestQuestions;
                  List<String> userAnswers = List.generate(
                      contestQuestions.length,
                      (index) => contestQuestions[index].userAnswer);

                  return Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      centerTitle: true,
                      leading: InkWell(
                        onTap: () {
                          context.pop();
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: Color(0xFF333333),
                          size: 32,
                        ),
                      ),
                      title: Text(
                        AppLocalizations.of(context)!.contest_analysis,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFFF6652),
                        ),
                      ),
                    ),
                    body: questionWidget(
                      contestQuestions: contestQuestions,
                      goTo: goTo,
                      context: context,
                      userAnswers: userAnswers,
                      correctAnswers: contestQuestions
                          .map((contestQuestion) => contestQuestion.answer)
                          .toList(),
                      questionMode: QuestionMode.analysis,
                      pageIndex: pageIndex,
                      params: widget.contestQuestionByCategoryPageparams,
                    ),
                  );
                }
                return Container();
              },
            )
          : BlocBuilder<FetchContestQuestionsByCategoryBloc,
              FetchContestQuestionsByCategoryState>(
              builder: (_, state) {
                if (state is FetchContestQuestionsByCategoryFailed) {
                  return Scaffold(
                    body: Center(
                      child: Text(AppLocalizations.of(context)!.error_loading_question),
                    ),
                  );
                } else if (state is FetchContestQuestionsByCategoryLoading) {
                  return Scaffold(
                    body: QuestionShimmerCard(),
                  );
                } else if (state is FetchContestQuestionsByCategoryLoaded) {
                  List<ContestQuestion> contestQuestions =
                      state.contestQuestions;

                  return Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      centerTitle: true,
                      leading: InkWell(
                        onTap: () {
                          showPopupOnQuitButtonPressed(
                            context: context,
                            onQuitPressed: () {
                              context.read<ContestDetailBloc>().add(
                                  GetContestdetailEvent(
                                      contestId: widget
                                          .contestQuestionByCategoryPageparams
                                          .contestId));
                              context
                                  .read<PopupMenuBloc>()
                                  .add(QuitExamEvent());
                            },
                          );
                        },
                        child: const Icon(
                          Icons.arrow_back,
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
                                showPopupOnQuitButtonPressed(
                                  context: context,
                                  onQuitPressed: () {
                                    context.read<ContestDetailBloc>().add(
                                        GetContestdetailEvent(
                                            contestId: widget
                                                .contestQuestionByCategoryPageparams
                                                .contestId));
                                    context
                                        .read<PopupMenuBloc>()
                                        .add(QuitExamEvent());
                                  },
                                );
                              },
                              child: Text(
                                AppLocalizations.of(context)!.quit,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    body: questionWidget(
                      contestQuestions: contestQuestions,
                      goTo: goTo,
                      context: context,
                      pageIndex: pageIndex,
                      params: widget.contestQuestionByCategoryPageparams,
                    ),
                  );
                }
                return Container();
              },
            ),
    );
  }

  Stack questionWidget({
    required List<ContestQuestion> contestQuestions,
    required Function(int) goTo,
    required BuildContext context,
    List<String> userAnswers = const [],
    List<String> correctAnswers = const [],
    QuestionMode questionMode = QuestionMode.quiz,
    required int pageIndex,
    required ContestQuestionByCategoryPageParams params,
  }) {
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
                        value: (currentIndex + 1) / contestQuestions.length,
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
                    itemCount: contestQuestions.length,
                    controller: _pageController,
                    onPageChanged: ((value) {
                      goTo(value);
                    }),
                    itemBuilder: (context, index) {
                      ContestQuestion question = contestQuestions[index];

                      return ContestQuestionSection(
                        examId: question.id,
                        isLiked: false,
                        question: question,
                        currentIndex: index,
                        totalQuestions: contestQuestions.length,
                        userChoice: questionMode == QuestionMode.quiz
                            ? userChoices[selectedCategory]![index]
                            : userAnswers[index],
                        onAnswerSelected: (selectedOption) {
                          setState(() {
                            userChoices[selectedCategory]![index] =
                                selectedOption;
                          });
                        },
                        userAnswers: questionMode == QuestionMode.quiz
                            ? userChoices[selectedCategory]!
                            : userAnswers,
                        goTo: goTo,
                        correctAnswers: correctAnswers,
                        questionMode: questionMode,
                        params: widget.contestQuestionByCategoryPageparams,
                      );
                    },
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: ContestQuestionBottomNavBar(
                      updateSubmittedCategories: updateSubmittedCategories,
                      submittedCategories: submittedCategories,
                      categoryId: selectedCategory,
                      categories: widget.contestQuestionByCategoryPageparams
                          .contestCategories,
                      index: currentIndex,
                      totalQuestions: contestQuestions.length,
                      goTo: goTo,
                      onSubmit: onSubmit,
                      changeCategory: changeCategory,
                      hasEnded:
                          widget.contestQuestionByCategoryPageparams.hasEnded,
                    ),
                  ),
                  if (questionMode != QuestionMode.quiz)
                    Positioned(
                      right: 10.w,
                      bottom: 15.h,
                      // child: FloatingOptions(
                      //   hideChat: questionMode == QuestionMode.quiz,
                      //   chatCallback: () {
                      // ContestQuestionByCategoryChatWithAIPageRoute(
                      //   id: widget
                      //       .contestQuestionByCategoryPageparams.contestId,
                      //   questionId: contestQuestions[pageIndex].id,
                      //   question:
                      //       '${contestQuestions[pageIndex].description}\nA) ${contestQuestions[pageIndex].choiceA}\nB) ${contestQuestions[pageIndex].choiceB}\nC) ${contestQuestions[pageIndex].choiceC}\nD) ${contestQuestions[pageIndex].choiceD}',
                      //   $extra: params,
                      // ).go(context);
                      //   },
                      //   flagCallback: () {
                      // showDialog(
                      //   context: context,
                      //   builder: (BuildContext context) {
                      //     return FlagDialog(
                      //       index: 0,
                      //       id: contestQuestions[currentIndex].id,
                      //       feedbackType: FeedbackType.questionFeedback,
                      //     );
                      //   },
                      // );
                      //   },
                      // ),
                      child: InkWell(
                        onTap: () {
                          ContestQuestionByCategoryChatWithAIPageRoute(
                            id: widget
                                .contestQuestionByCategoryPageparams.contestId,
                            questionId: contestQuestions[pageIndex].id,
                            question:
                                '${contestQuestions[pageIndex].description}\nA) ${contestQuestions[pageIndex].choiceA}\nB) ${contestQuestions[pageIndex].choiceB}\nC) ${contestQuestions[pageIndex].choiceC}\nD) ${contestQuestions[pageIndex].choiceD}',
                            $extra: params,
                          ).go(context);
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
}
