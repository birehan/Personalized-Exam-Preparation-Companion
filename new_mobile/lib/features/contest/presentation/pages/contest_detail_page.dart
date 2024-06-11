import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:prep_genie/core/widgets/share.dart';
import 'package:prep_genie/features/contest/presentation/bloc/contest_ranking_bloc/contest_ranking_bloc.dart';
import 'package:prep_genie/features/contest/presentation/bloc/registerContest/register_contest_bloc.dart';
import 'package:prep_genie/features/contest/presentation/widgets/contest_ranking_section.dart';
import 'package:prep_genie/features/contest/presentation/widgets/weekly_prizes_widget.dart';
import 'package:prep_genie/features/features.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/core.dart';
import '../../../../core/utils/snack_bar.dart';

class ContestDetailPage extends StatefulWidget {
  const ContestDetailPage({
    super.key,
    required this.contestId,
  });

  final String contestId;

  @override
  State<ContestDetailPage> createState() => _ContestDetailPageState();
}

class _ContestDetailPageState extends State<ContestDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  String timeLeftMessage = "";
  late Timer _timer;
  Duration timeLeft = const Duration(seconds: 0);
  Set submittedCategories = {};
  bool isShareInProgress = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController = ScrollController();
    context.read<ContestDetailBloc>().add(
          GetContestdetailEvent(contestId: widget.contestId),
        );
    // context.read<FetchContestByIdBloc>().add(
    //       FetchContestByIdEvent(contestId: widget.contestId),
    //     );

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _timer.cancel();
    super.dispose();
  }

  void onCountDown(Duration duration) {
    setState(() {
      timeLeft = duration;
    });
  }

  void showContestRegisteredMessage(BuildContext context) {
    showGeneralDialog(
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black38,
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, anim1, anim2) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("You haven't registered for any contests yet."),
            //  Text(AppLocalizations.of(context)!.you_have_not_registered_for_any_contests_yet),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    context.read<ContestDetailBloc>().add(
                        GetContestdetailEvent(contestId: widget.contestId));
                    Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 40.w,
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xff18786a),
                    ),
                    child: const Text(
                      // AppLocalizations.of(context)!.ok,
                      'OK',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Poppins'),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
      transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
        filter: ui.ImageFilter.blur(
            sigmaX: 4 * anim1.value, sigmaY: 4 * anim1.value),
        child: FadeTransition(
          opacity: anim1,
          child: child,
        ),
      ),
      context: context,
    );
  }

  void updateSubmittedCategories(String categoryId) {
    setState(() {
      submittedCategories.add(categoryId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvoked: (didPop) {
          context
              .read<FetchUpcomingUserContestBloc>()
              .add(FetchUpcomingContestEvent());
          context
              .read<FetchPreviousContestsBloc>()
              .add(const FetchPreviousContestsEvent());
          context
              .read<FetchPreviousUserContestsBloc>()
              .add(const FetchPreviousUserContestsEvent());
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFFAFAFA),
          body: BlocListener<RegisterContestBloc, RegisterContestState>(
            listener: (context, state) {
              if (state is RegisterContestSuccessfulState) {
                showContestRegisteredMessage(context);
              } else if (state is RegisterContestFailedState &&
                  state.failure is RequestOverloadFailure) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(snackBar(state.failure.errorMessage));
              }
            },
            child: BlocListener<ContestDetailBloc, ContestDetailState>(
              listener: (context, state) {
                if (state is ContestDetailFailedState) {
                  if (state.failureType is RequestOverloadFailure) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(snackBar(state.failureType.errorMessage));
                  }
                }
              },
              child: BlocBuilder<ContestDetailBloc, ContestDetailState>(
                builder: (context, state) {
                  if (state is ContestDetailFailedState) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: EmptyListWidget(
                          showImage: false,
                          message: AppLocalizations.of(context)!
                              .check_your_internet_connection_and_try_again,
                          reloadCallBack: () {
                            context.read<ContestDetailBloc>().add(
                                GetContestdetailEvent(
                                    contestId: widget.contestId));
                            context
                                .read<ContestRankingBloc>()
                                .add(const ContestRankingEvent());
                          },
                        ),
                      ),
                    );
                  } else if (state is ContestDetailLoadingState) {
                    return const LinearProgressIndicator();
                  } else if (state is ContestDetailLoadedState) {
                    final contestPrizes = state.contestDetail.contestPrizes;
                    final contestCategories =
                        state.contestDetail.contestCategories;

                    // print('hasRegistered: ${state.contestDetail.hasRegistered}');
                    // print('hasEnded: ${state.contestDetail.hasEnded}');

                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<ContestDetailBloc>().add(
                            GetContestdetailEvent(
                                contestId: state.contestDetail.contestId));
                      },
                      child: NestedScrollView(
                        controller: _scrollController,
                        headerSliverBuilder: (context, value) {
                          return [
                            SliverAppBar(
                              pinned: true,
                              snap: false,
                              elevation: 0,
                              scrolledUnderElevation: 0,
                              leading: IconButton(
                                icon: const Icon(Icons.arrow_back),
                                onPressed: () {
                                  context
                                      .read<FetchUpcomingUserContestBloc>()
                                      .add(FetchUpcomingContestEvent());
                                  context
                                      .read<FetchPreviousContestsBloc>()
                                      .add(const FetchPreviousContestsEvent());
                                  context
                                      .read<FetchPreviousUserContestsBloc>()
                                      .add(
                                          const FetchPreviousUserContestsEvent());
                                  context.pop();
                                },
                              ),
                              // expandedHeight: 100,
                              title: Text(
                                state.contestDetail.title,
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              actions: [
                                ShareButton(
                                  route: '/contest/${widget.contestId}',
                                  subject: 'SkillBridge weekly contest',
                                )
                              ],
                            ),
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 12, left: 12, right: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (state.contestDetail.isUpcoming &&
                                        state.contestDetail.isLive)
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin:
                                            const EdgeInsets.only(bottom: 20),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 12),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF3FCC69),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .the_contest_is_live,
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    const SizedBox(height: 8),
                                    Text(
                                      state.contestDetail.description,
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    (state.contestDetail.hasRegistered &&
                                                state.contestDetail.hasEnded) ||
                                            (state.contestDetail.contestType !=
                                                    'live' &&
                                                state
                                                        .contestDetail
                                                        .contestCategories
                                                        .length ==
                                                    submittedCategories.length)
                                        ? ContestResultWidget(
                                            contestStartTime:
                                                state.contestDetail.startsAt,
                                            contestEndTime:
                                                state.contestDetail.endsAt,
                                            points:
                                                state.contestDetail.userScore,
                                            rank: state.contestDetail.userRank,
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.schedule,
                                                      color: Color(0xFF888888),
                                                    ),
                                                    const SizedBox(width: 6),
                                                    ContestTimeCountdown(
                                                      timeLeft: Duration(
                                                          seconds: state
                                                              .contestDetail
                                                              .timeLeft
                                                              .toInt()),
                                                      isLive: state
                                                              .contestDetail
                                                              .contestType ==
                                                          'live',
                                                      hasRegistered: state
                                                          .contestDetail
                                                          .hasRegistered,
                                                      onCountDown: onCountDown,
                                                      contestType: state
                                                          .contestDetail
                                                          .contestType,
                                                      contestId: state
                                                          .contestDetail
                                                          .contestId,
                                                    )
                                                  ],
                                                ),
                                              ),
                                              state.contestDetail.hasEnded
                                                  ? Container()
                                                  : !state.contestDetail
                                                          .hasRegistered
                                                      ? InkWell(
                                                          onTap: () {
                                                            context
                                                                .read<
                                                                    RegisterContestBloc>()
                                                                .add(
                                                                  RegisterUserToContestEvent(
                                                                    contestId:
                                                                        widget
                                                                            .contestId,
                                                                  ),
                                                                );
                                                          },
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            width: 30.w,
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        12),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: const Color(
                                                                  0xFF1A7A6C),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6),
                                                            ),
                                                            child: BlocBuilder<
                                                                RegisterContestBloc,
                                                                RegisterContestState>(
                                                              builder: (context,
                                                                  registerContestState) {
                                                                if (registerContestState
                                                                    is RegisterContestInprogressState) {
                                                                  return const CustomProgressIndicator(
                                                                      color: Colors
                                                                          .white,
                                                                      size: 14);
                                                                }
                                                                return Text(
                                                                  state
                                                                          .contestDetail
                                                                          .isUpcoming
                                                                      ? AppLocalizations.of(
                                                                              context)!
                                                                          .register_now
                                                                      : AppLocalizations.of(
                                                                              context)!
                                                                          .try_contest,
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        )
                                                      : Row(
                                                          children: [
                                                            const Icon(
                                                              Icons.check,
                                                              color: Color(
                                                                  0xFF3DB861),
                                                            ),
                                                            const SizedBox(
                                                                width: 4),
                                                            Text(
                                                              AppLocalizations.of(
                                                                      context)!
                                                                  .registered,
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                color: const Color(
                                                                    0xFF3DB861),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                            ],
                                          ),
                                    if (state
                                        .contestDetail.contestPrizes.isNotEmpty)
                                      Column(
                                        children: [
                                          const SizedBox(height: 24),
                                          Row(
                                            children: [
                                              Image.asset(
                                                'assets/images/weekly_prize.png',
                                                width: 20,
                                                height: 20,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                AppLocalizations.of(context)!
                                                    .weekly_prizes,
                                                style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Image.asset(
                                                'assets/images/weekly_prize.png',
                                                width: 20,
                                                height: 20,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16, horizontal: 16),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(.03),
                                                  blurRadius: 8,
                                                  spreadRadius: 4,
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              children: List.generate(
                                                contestPrizes.length,
                                                (index) => Container(
                                                  margin: EdgeInsets.only(
                                                      bottom:
                                                          index == 4 ? 0 : 8),
                                                  child: WeeklyPrizeDisplay(
                                                    place: index + 1,
                                                    prizeMoney:
                                                        contestPrizes[index]
                                                            .amount,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            SliverAppBar(
                              pinned: true,
                              snap: false,
                              elevation: 0,
                              scrolledUnderElevation: 0,
                              automaticallyImplyLeading: false,
                              title: TabBar(
                                controller: _tabController,
                                labelColor: Colors.black,
                                unselectedLabelColor: const Color(0xFF727171),
                                indicatorSize: TabBarIndicatorSize.tab,
                                tabs: [
                                  Tab(
                                    child: Text(
                                      AppLocalizations.of(context)!.questions,
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Tab(
                                    child: Text(
                                      AppLocalizations.of(context)!.ranking,
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                                onTap: (index) {
                                  if (index == 1) {
                                    context.read<ContestRankingBloc>().add(
                                        GetContestRankingEvent(
                                            contestId: widget.contestId));
                                  }
                                },
                              ),
                            ),
                          ];
                        },
                        body: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 12),
                          child: Column(
                            children: [
                              Expanded(
                                child: TabBarView(
                                  controller: _tabController,
                                  children: [
                                    Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        ListView.separated(
                                          itemCount: contestCategories.length,
                                          separatorBuilder: (context, index) =>
                                              Container(
                                            height: 1,
                                            color: const Color(0xFFE4E4E4),
                                          ),
                                          itemBuilder: (context, index) =>
                                              InkWell(
                                            onTap: () {
                                              if (state
                                                      .contestDetail.hasEnded ||
                                                  (!contestCategories[index]
                                                          .isSubmitted &&
                                                      !state.contestDetail
                                                          .hasEnded)) {
                                                ContestQuestionByCategoryPageRoute(
                                                  id: widget.contestId,
                                                  $extra:
                                                      ContestQuestionByCategoryPageParams(
                                                    categoryId:
                                                        contestCategories[index]
                                                            .categoryId,
                                                    timeLeft: timeLeft,
                                                    contestCategories:
                                                        contestCategories,
                                                    contestId: state
                                                        .contestDetail
                                                        .contestId,
                                                    updateSubmittedCategories:
                                                        updateSubmittedCategories,
                                                    hasEnded: state
                                                        .contestDetail.hasEnded,
                                                  ),
                                                ).go(context);
                                              } else {
                                                showPopupOnCompletingContest(
                                                  context: context,
                                                  onCompleted: () {},
                                                  title: state.contestDetail
                                                          .hasEnded
                                                      ? AppLocalizations.of(
                                                              context)!
                                                          .contest_has_ended
                                                      : AppLocalizations.of(
                                                              context)!
                                                          .you_have_submitted_for_this_category_successfully,
                                                  isSubmitted: !state
                                                      .contestDetail.hasEnded,
                                                );
                                              }
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                  top: Radius.circular(
                                                      index == 0 ? 4 : 0),
                                                  bottom: Radius.circular(
                                                      index ==
                                                              contestCategories
                                                                      .length -
                                                                  1
                                                          ? 4
                                                          : 0),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          ConstrainedBox(
                                                            constraints:
                                                                BoxConstraints(
                                                              maxWidth: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.6,
                                                            ),
                                                            child: Text(
                                                              contestCategories[
                                                                      index]
                                                                  .title,
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 6),
                                                          if (state
                                                                  .contestDetail
                                                                  .hasRegistered &&
                                                              state
                                                                  .contestDetail
                                                                  .hasEnded)
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          6,
                                                                      horizontal:
                                                                          4),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: const Color(
                                                                        0xFF18786A)
                                                                    .withOpacity(
                                                                        0.11),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4),
                                                              ),
                                                              child: Text(
                                                                '${contestCategories[index].userScore}${AppLocalizations.of(context)!.pts}',
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  color:
                                                                      const Color(
                                                                    0xFF18786A,
                                                                  ),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                      ConstrainedBox(
                                                        constraints:
                                                            BoxConstraints(
                                                          maxWidth: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.5,
                                                        ),
                                                        child: Text(
                                                          '${contestCategories[index].numberOfQuestion.toString()} ${AppLocalizations.of(context)!.questions}',
                                                          style: GoogleFonts
                                                              .poppins(
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    width: 24,
                                                    height: 24,
                                                    decoration: BoxDecoration(
                                                      color: (!contestCategories[
                                                                      index]
                                                                  .isSubmitted &&
                                                              state
                                                                  .contestDetail
                                                                  .hasEnded)
                                                          ? const Color(
                                                              0xFFFF6652)
                                                          : const Color(
                                                              0xFF1A7A6C),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Icon(
                                                      contestCategories[index]
                                                              .isSubmitted
                                                          ? Icons.check
                                                          : (!contestCategories[
                                                                          index]
                                                                      .isSubmitted &&
                                                                  state
                                                                      .contestDetail
                                                                      .hasEnded)
                                                              ? Icons.close
                                                              : Icons
                                                                  .keyboard_arrow_right_outlined,
                                                      color: Colors.white,
                                                      size: 18,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        if (!state
                                                .contestDetail.hasRegistered ||
                                            (state.contestDetail.contestType ==
                                                    'live' &&
                                                !state.contestDetail.hasEnded &&
                                                !state.contestDetail.isLive))
                                          BackdropFilter(
                                            filter: ui.ImageFilter.blur(
                                              sigmaX: 8.0,
                                              sigmaY: 8.0,
                                            ),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height,
                                              decoration: const BoxDecoration(
                                                color: Colors.transparent,
                                                // Colors.grey.shade200.withOpacity(0.9),
                                              ),
                                              child: const Center(
                                                child: Icon(
                                                  Icons.lock,
                                                  color: Color(0XFF1A7A6C),
                                                  size: 48,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        ContestRankingSection(
                                            contestId: widget.contestId),
                                        if (!state
                                                .contestDetail.hasRegistered ||
                                            (state.contestDetail.contestType ==
                                                    'live' &&
                                                !state.contestDetail.hasEnded &&
                                                !state.contestDetail.isLive))
                                          BackdropFilter(
                                            filter: ui.ImageFilter.blur(
                                              sigmaX: 8.0,
                                              sigmaY: 8.0,
                                            ),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height,
                                              decoration: const BoxDecoration(
                                                color: Colors.transparent,
                                                // Colors.grey.shade200.withOpacity(0.9),
                                              ),
                                              child: const Center(
                                                child: Icon(
                                                  Icons.lock,
                                                  color: Color(0XFF1A7A6C),
                                                  size: 48,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ),
          ),
        ));
  }
}

class ContestResultWidget extends StatelessWidget {
  const ContestResultWidget({
    super.key,
    required this.contestStartTime,
    required this.contestEndTime,
    required this.points,
    required this.rank,
  });

  final DateTime contestStartTime;
  final DateTime contestEndTime;
  final int points;
  final int rank;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 28.w,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F7F7),
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                spreadRadius: 6,
                blurRadius: 8,
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                timeFormatCalculate(
                    contestEndTime.difference(contestStartTime)),
                style: GoogleFonts.poppins(
                  color: const Color(0xFF232828),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                AppLocalizations.of(context)!.time_spent,
                style: GoogleFonts.poppins(
                  color: const Color(0xFF7E7E7E),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 28.w,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F7F7),
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                spreadRadius: 6,
                blurRadius: 8,
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/left_laurel_wreath.png',
                  width: 32, height: 40),
              Column(
                children: [
                  Text(
                    '$points',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF232828),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppLocalizations.of(context)!.points,
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF7E7E7E),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Image.asset('assets/images/right_laurel_wreath.png',
                  width: 32, height: 40),
            ],
          ),
        ),
        rank == -1
            ? Container(width: 30.w)
            : Container(
                width: 30.w,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F7F7),
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      spreadRadius: 6,
                      blurRadius: 8,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      '$rank',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF232828),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppLocalizations.of(context)!.rank,
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF7E7E7E),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
      ],
    );
  }
}

class ContestTimeCountdown extends StatefulWidget {
  const ContestTimeCountdown({
    super.key,
    required this.timeLeft,
    required this.isLive,
    required this.hasRegistered,
    required this.onCountDown,
    required this.contestId,
    required this.contestType,
  });

  final Duration timeLeft;
  final bool isLive;
  final bool hasRegistered;
  final Function(Duration) onCountDown;
  final String contestId;
  final String contestType;

  @override
  State<ContestTimeCountdown> createState() => _ContestTimeCountdownState();
}

class _ContestTimeCountdownState extends State<ContestTimeCountdown> {
  late Timer _timer;
  int duration = 0;
  String timeLeftMessage = '';

  @override
  void initState() {
    super.initState();
    duration = widget.timeLeft.inSeconds;

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        // timeLeftMessage = calculateTimeLeft(
        //   state.contestDetail.startsAt,
        //   state.contestDetail.endsAt,
        //   state.contestDetail.isUpcoming,
        //   state.contestDetail.hasRegistered,
        //   state.contestDetail.contestType,
        // );
        if (duration < 0) {
          context
              .read<ContestDetailBloc>()
              .add(GetContestdetailEvent(contestId: widget.contestId));
          _timer.cancel();
          timeLeftMessage = AppLocalizations.of(context)!.contest_has_ended;
        } else if (!widget.isLive && !widget.hasRegistered) {
          timeLeftMessage = timeFormatCalculate(widget.timeLeft);
        } else {
          duration--;
          timeLeftMessage = timeFormatCalculate(Duration(seconds: duration));
        }

        widget.onCountDown(Duration(seconds: duration));
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      timeLeftMessage,
      style: GoogleFonts.poppins(
        color: const Color(0xFF3E3B3B),
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
