import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skill_bridge_mobile/core/widgets/noInternet.dart';
import 'package:skill_bridge_mobile/core/widgets/tooltip_widget.dart';
import 'package:skill_bridge_mobile/features/contest/contest.dart';
import 'package:skill_bridge_mobile/features/home/presentation/widgets/count_down_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/core.dart';

class ContestsMainPage extends StatefulWidget {
  const ContestsMainPage({super.key});

  @override
  State<ContestsMainPage> createState() => _ContestsMainPageState();
}

class _ContestsMainPageState extends State<ContestsMainPage>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  int _tabIndex = 0;
  late Timer _timer;
  final _scrollController = ScrollController();

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      setState(() {
        _tabIndex = _tabController.index;
      });
    });

    context
        .read<FetchPreviousContestsBloc>()
        .add(const FetchPreviousContestsEvent());
    context
        .read<FetchPreviousUserContestsBloc>()
        .add(const FetchPreviousUserContestsEvent());
    context
        .read<FetchUpcomingUserContestBloc>()
        .add(FetchUpcomingContestEvent());

    _timer = Timer.periodic(const Duration(seconds: 0), (timer) {});
    super.initState();
  }

  @override
  void dispose() {
    _tabController.removeListener(() {});
    _tabController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, value) => [
          SliverAppBar(
            pinned: true,
            snap: false,
            elevation: 0,
            scrolledUnderElevation: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.contests,
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 2.w),
                TooltipWidget(
                    iconSize: 20,
                    message: AppLocalizations.of(context)!.contest_info),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 3.h, left: 5.w, right: 5.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    // height: 37.h,
                    constraints: BoxConstraints(
                      minHeight: 37.h, // Set your desired minimum height
                    ),
                    padding: EdgeInsets.only(
                        left: 4.w, right: 4.w, top: 2.h, bottom: .5.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: const LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: [
                          Color(0xff2F92AF),
                          Color(0xff30377D),
                        ],
                      ),
                    ),
                    child: BlocBuilder<FetchUpcomingUserContestBloc,
                        FetchUpcomingUserContestState>(
                      builder: (context, state) {
                        if (state is UpcomingContestFailredState) {
                          if (state.failureType is NetworkFailure) {
                            return NoInternet(
                              setColor: true,
                              reloadCallback: () {
                                context
                                    .read<FetchUpcomingUserContestBloc>()
                                    .add(FetchUpcomingContestEvent());
                              },
                              // setColor: true,
                            );
                          }
                          return const Center(
                            child: Text('Something is not right'),
                          );
                        } else if (state is UpcomingContestLoadingState) {
                          return _contestTimerBoxShimmer();
                        } else if (state is UpcomingContestFetchedState) {
                          final contest = state.upcomingContes;
                          if (contest == null) {
                            // no contest available
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/noContest.png',
                                  height: 8.h,
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  AppLocalizations.of(context)!.no_contest,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Poppins'),
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  "${AppLocalizations.of(context)!.no_contest_text} 🌟",
                                  style: const TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            );
                          }
                          // contest available
                          return UpcomingContestCard(contest: contest);
                        }
                        return Container();
                      },
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    AppLocalizations.of(context)!.previous_contests,
                    style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: true,
            snap: false,
            elevation: 0,
            scrolledUnderElevation: 0,
            title: TabBar(
              indicatorColor: const Color(0xff18786a),
              labelColor: Colors.black,
              unselectedLabelStyle: const TextStyle(color: Colors.grey),
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Tab(
                  child: Text(
                    AppLocalizations.of(context)!.all_contests,
                    style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Tab(
                  child: Text(
                    AppLocalizations.of(context)!.my_contests,
                    style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
        body: Padding(
          padding: EdgeInsets.only(left: 5.w, right: 5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const Text(
              //   'Previous Contests',
              //   style: TextStyle(
              //       fontFamily: 'Poppins',
              //       fontSize: 20,
              //       fontWeight: FontWeight.w600),
              // ),
              // SizedBox(height: 4.h),
              // TabBar(
              //   indicatorColor: const Color(0xff18786a),
              //   labelColor: Colors.black,
              //   unselectedLabelStyle: const TextStyle(color: Colors.grey),
              //   controller: _tabController,
              //   indicatorSize: TabBarIndicatorSize.tab,
              //   tabs: const [
              //     Tab(
              //       child: Text(
              //         'All Contests',
              //         style: TextStyle(
              //             fontFamily: 'Poppins',
              //             fontSize: 18,
              //             fontWeight: FontWeight.w600),
              //       ),
              //     ),
              //     Tab(
              //       child: Text(
              //         'My Contests',
              //         style: TextStyle(
              //             fontFamily: 'Poppins',
              //             fontSize: 18,
              //             fontWeight: FontWeight.w600),
              //       ),
              //     ),
              //   ],
              // ),
              SizedBox(height: 3.h),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    BlocBuilder<FetchPreviousContestsBloc,
                        FetchPreviousContestsState>(
                      builder: (context, state) {
                        if (state is FetchPreviousContestsLoading) {
                          return ListView.separated(
                            itemBuilder: (context, index) {
                              return _contestLoadingShimmer();
                            },
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 2.h),
                            itemCount: 3,
                          );
                        } else if (state is FetchPreviousContestsLoaded) {
                          if (state.contests.isEmpty) {
                            return SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: EmptyListWidget(
                                  width: 100,
                                  height: 100,
                                  message: 'Coming Soon! No contests here yet.',
                                  reloadCallBack: () {
                                    context
                                        .read<FetchPreviousContestsBloc>()
                                        .add(
                                            const FetchPreviousContestsEvent());
                                  },
                                ),
                              ),
                            );
                          }
                          return RefreshIndicator(
                            onRefresh: () async {
                              context
                                  .read<FetchPreviousContestsBloc>()
                                  .add(const FetchPreviousContestsEvent());
                            },
                            child: ListView.separated(
                              itemBuilder: (context, index) {
                                return ContestListCard(
                                    contest: state.contests[index]);
                              },
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 2.h),
                              itemCount: state.contests.length,
                            ),
                          );
                        } else {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: EmptyListWidget(
                                showImage: false,
                                message:
                                    'Check your internet connection and try again.',
                                reloadCallBack: () {
                                  context
                                      .read<FetchPreviousContestsBloc>()
                                      .add(const FetchPreviousContestsEvent());
                                },
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    BlocBuilder<FetchPreviousUserContestsBloc,
                        FetchPreviousUserContestsState>(
                      builder: (context, state) {
                        if (state is FetchPreviousUserContestsLoading) {
                          return ListView.separated(
                            itemBuilder: (context, index) {
                              return _contestLoadingShimmer();
                            },
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 2.h),
                            itemCount: 3,
                          );
                        } else if (state is FetchPreviousUserContestsLoaded) {
                          if (state.contests.isEmpty) {
                            return SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: EmptyListWidget(
                                  width: 100,
                                  height: 100,
                                  message:
                                      'You haven\'t registered for any contests yet.',
                                  reloadCallBack: () {
                                    context
                                        .read<FetchPreviousUserContestsBloc>()
                                        .add(
                                            const FetchPreviousUserContestsEvent());
                                  },
                                ),
                              ),
                            );
                          }
                          return RefreshIndicator(
                            onRefresh: () async {
                              context
                                  .read<FetchPreviousUserContestsBloc>()
                                  .add(const FetchPreviousUserContestsEvent());
                            },
                            child: ListView.separated(
                              itemBuilder: (context, index) {
                                return ContestListCard(
                                    contest: state.contests[index]);
                              },
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 2.h),
                              itemCount: state.contests.length,
                            ),
                          );
                        } else {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: EmptyListWidget(
                                showImage: false,
                                message:
                                    'Check your internet connection and try again.',
                                reloadCallBack: () {
                                  context
                                      .read<FetchPreviousUserContestsBloc>()
                                      .add(
                                          const FetchPreviousUserContestsEvent());
                                },
                              ),
                            ),
                          );
                        }
                      },
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

  Shimmer _contestLoadingShimmer() {
    return Shimmer.fromColors(
      direction: ShimmerDirection.ttb,
      baseColor: const Color.fromARGB(255, 236, 235, 235),
      highlightColor: const Color(0xffF9F8F8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 3.h,
                    width: 30.w,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(3)),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 2.h,
                    width: 50.w,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(3)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 70,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Shimmer _contestTimerBoxShimmer() {
    return Shimmer.fromColors(
      direction: ShimmerDirection.ttb,
      baseColor: Colors.black,
      highlightColor: Colors.white70,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 3.h,
                  width: 20.w,
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(10)),
                ),
                Container(
                  height: 3.h,
                  width: 25.w,
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(10)),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            Container(
              height: 4.h,
              width: 50.w,
              decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(10)),
            ),
            SizedBox(height: 2.h),
            Container(
              height: 5.h,
              width: 80.w,
              decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(10)),
            ),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 5.h,
                  width: 40.w,
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(20)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class UpcomingContestCard extends StatefulWidget {
  const UpcomingContestCard({
    super.key,
    required this.contest,
  });

  final Contest contest;

  @override
  State<UpcomingContestCard> createState() => _UpcomingContestCardState();
}

class _UpcomingContestCardState extends State<UpcomingContestCard> {
  late Timer _timer;
  late int _countDownDuration;

  @override
  void initState() {
    super.initState();
    _countDownDuration = widget.contest.timeLeft;
    if (_countDownDuration < 0) {
      _countDownDuration = 0;
    }

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (_countDownDuration > 0) {
          setState(() {
            _countDownDuration--;
          });
        } else {
          context
              .read<FetchUpcomingUserContestBloc>()
              .add(FetchUpcomingContestEvent());
          _timer.cancel();
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widget.contest.live!
                ? Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 230, 71, 71),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.sensors_rounded, color: Colors.white),
                        const SizedBox(width: 6),
                        Text(
                          AppLocalizations.of(context)!.live,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                : Text(
                    AppLocalizations.of(context)!.upcoming,
                    style: const TextStyle(
                        color: Colors.white, fontFamily: 'Poppins'),
                  ),
            Text(
              DateFormat('MMM dd, yyyy').format(widget.contest.startsAt),
              style:
                  const TextStyle(color: Colors.white, fontFamily: 'Poppins'),
            )
          ],
        ),
        SizedBox(height: 3.h),
        Text(
          widget.contest.title,
          style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins',
              fontSize: 22,
              fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 2.h),
        CountDownCard(
          timeLeft: _countDownDuration,
          forContest: true,
        ),
        SizedBox(height: 3.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.contest.hasRegistered != null &&
                    widget.contest.hasRegistered! &&
                    !widget.contest.live!
                ? InkWell(
                    onTap: () {
                      ContestDetailPageRoute(
                        id: widget.contest.id,
                      ).go(context);
                    },
                    child: Container(
                      // width: 40.w,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 1.5.h),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle,
                              color: Color(0xff30377D)),
                          SizedBox(width: 3.w),
                          Text(
                            AppLocalizations.of(context)!.registered,
                            style: const TextStyle(
                                color: Color(0xff30377D),
                                fontFamily: 'Poppins',
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  )
                : !widget.contest.hasRegistered!
                    ? InkWell(
                        onTap: () {
                          ContestDetailPageRoute(
                            id: widget.contest.id,
                          ).go(context);
                        },
                        child: Container(
                          // width: 40.w,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 1.5.h),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            // widget.contest.live != null && !widget.contest.live!
                            AppLocalizations.of(context)!.register,
                            style: const TextStyle(
                                color: Color(0xff30377D),
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      )
                    : InkWell(
                        onTap: () {
                          ContestDetailPageRoute(
                            id: widget.contest.id,
                          ).go(context);
                        },
                        child: Container(
                          // width: 40.w,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 1.5.h),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            // widget.contest.live != null && !widget.contest.live!
                            AppLocalizations.of(context)!.go_to_contest,
                            style: const TextStyle(
                                color: Color(0xff30377D),
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
          ],
        ),
        SizedBox(height: 1.h),
        if (widget.contest.liveRegister > 0)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.group, color: Colors.white),
              const SizedBox(width: 6),
              Text(
                '${widget.contest.liveRegister}',
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          )
      ],
    );
  }
}
