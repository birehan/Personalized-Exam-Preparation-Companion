import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skill_bridge_mobile/core/widgets/tooltip_widget.dart';
import 'package:skill_bridge_mobile/features/home/presentation/widgets/dynamic_homepage_header_section.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/core.dart';
import '../../../features.dart';

class DynamicHomePage extends StatefulWidget {
  const DynamicHomePage({super.key});

  @override
  State<DynamicHomePage> createState() => _DynamicHomePageState();
}

class _DynamicHomePageState extends State<DynamicHomePage> {
  List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  DateTime today = DateTime.now();

  @override
  void initState() {
    super.initState();
    DateTime mondayBefore = today.subtract(Duration(days: today.weekday - 1));
    DateTime sundayAfter = today.add(Duration(days: 7 - today.weekday));
    context.read<FetchDailyStreakBloc>().add(
        FetchDailyStreakEvent(startDate: mondayBefore, endDate: sundayAfter));
    context.read<HomeBloc>().add(const GetHomeEvent(refresh: true));
    context.read<FetchDailyQuizBloc>().add(const FetchDailyQuizEvent());
    context.read<GetUserBloc>().add(GetUserCredentialEvent());
    context.read<FetchDailyQuestBloc>().add(const FetchDailyQuestEvent());
  }

  OverlayEntry? overlayEntry;

  @override
  Widget build(BuildContext context) {
    GlobalKey iconKey = GlobalKey();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(top: 3.h, right: 5.w, left: 5.w),
        child: Column(
          children: [
            const DynamicHomepageProfileHeader(),
            SizedBox(height: 2.h),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(
                          left: 2.5.w, right: 2.5, top: 2.h, bottom: 1.h),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10,
                              spreadRadius: 4,
                              color: Colors.black.withOpacity(.04),
                              offset: const Offset(0, 1),
                            ),
                          ]),
                      child: BlocBuilder<FetchDailyStreakBloc,
                          FetchDailyStreakState>(
                        builder: (context, state) {
                          if (state is FetchDailyStreakLoading) {
                            return _dailyStreakShimmer();
                          } else if (state is FetchDailyStreakLoaded) {
                            Map<String, UserDailyStreak> userDailyStreakMap =
                                {};

                            for (var userDailyStreak
                                in state.dailyStreak.userDailyStreaks) {
                              userDailyStreakMap[
                                      '${userDailyStreak.date.weekday}'] =
                                  userDailyStreak;
                            }

                            return Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 1.5.w),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!
                                                .daily_streak,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Poppins'),
                                          ),
                                          SizedBox(width: 1.w),
                                          Text(
                                            '(${DateFormat('MMM dd').format(userDailyStreakMap['1']!.date)} - ${DateFormat('MMM dd').format(userDailyStreakMap['7']!.date)})',
                                            style: GoogleFonts.poppins(
                                              color: const Color(0xFF7D7D7D),
                                              fontSize: 13,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          if (!isSameDay(today, DateTime.now()))
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  today = DateTime.now();
                                                });
                                                DateTime mondayBefore =
                                                    today.subtract(Duration(
                                                        days:
                                                            today.weekday - 1));
                                                DateTime sundayAfter =
                                                    today.add(Duration(
                                                        days:
                                                            7 - today.weekday));
                                                context
                                                    .read<
                                                        FetchDailyStreakBloc>()
                                                    .add(FetchDailyStreakEvent(
                                                        startDate: mondayBefore,
                                                        endDate: sundayAfter));
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 6,
                                                        horizontal: 8),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFF18786A)
                                                      .withOpacity(0.11),
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  'Today',
                                                  style: GoogleFonts.poppins(
                                                    color:
                                                        const Color(0xFF18786A),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      TooltipWidget(
                                        message: AppLocalizations.of(context)!
                                            .daily_streak_info,
                                      )
                                    ],
                                  ),
                                ),
                                // SizedBox(height: 1.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          today = today.subtract(
                                              const Duration(days: 7));
                                        });
                                        DateTime mondayBefore = today.subtract(
                                            Duration(days: today.weekday - 1));
                                        DateTime sundayAfter = today.add(
                                            Duration(days: 7 - today.weekday));
                                        context
                                            .read<FetchDailyStreakBloc>()
                                            .add(FetchDailyStreakEvent(
                                                startDate: mondayBefore,
                                                endDate: sundayAfter));
                                      },
                                      child:
                                          const Icon(Icons.keyboard_arrow_left),
                                    ),
                                    Expanded(
                                      child: SizedBox(
                                        height: 10.h,
                                        child: ListView.separated(
                                          itemCount: 7,
                                          scrollDirection: Axis.horizontal,
                                          separatorBuilder: (context, index) =>
                                              Container(
                                            width: 5.w,
                                            alignment: Alignment.bottomCenter,
                                            padding:
                                                EdgeInsets.only(bottom: 2.8.h),
                                            child: Container(
                                                height: 1,
                                                color: !userDailyStreakMap[
                                                            '${index + 1}']!
                                                        .activeOnDay
                                                    ? const Color.fromARGB(
                                                        255, 214, 213, 213)
                                                    : const Color(0xffF53A04)),
                                          ),
                                          itemBuilder: (context, index) =>
                                              Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                days[index],
                                                style: const TextStyle(
                                                    fontSize: 11,
                                                    fontFamily: 'Poppins',
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                              SizedBox(height: 1.h),
                                              Image(
                                                  image: userDailyStreakMap[
                                                              '${index + 1}']!
                                                          .activeOnDay
                                                      ? const AssetImage(
                                                          'assets/images/fireRed.png')
                                                      : const AssetImage(
                                                          'assets/images/fireGrey.png'),
                                                  height: 25,
                                                  width: 25),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: isSameDay(today, DateTime.now())
                                          ? null
                                          : () {
                                              setState(() {
                                                today = today.add(
                                                    const Duration(days: 7));
                                              });
                                              DateTime mondayBefore =
                                                  today.subtract(Duration(
                                                      days: today.weekday - 1));
                                              DateTime sundayAfter = today.add(
                                                  Duration(
                                                      days: 7 - today.weekday));
                                              context
                                                  .read<FetchDailyStreakBloc>()
                                                  .add(FetchDailyStreakEvent(
                                                      startDate: mondayBefore,
                                                      endDate: sundayAfter));
                                            },
                                      child: const Icon(
                                          Icons.keyboard_arrow_right),
                                    ),
                                  ],
                                )
                              ],
                            );
                          } else if (state is FetchDailyStreakFailed) {
                            return Center(
                              child: EmptyListWidget(
                                showImage: false,
                                message:
                                    'Check your internet connection and try again.',
                                reloadCallBack: () {
                                  DateTime mondayBefore = today.subtract(
                                      Duration(days: today.weekday - 1));
                                  DateTime sundayAfter = today
                                      .add(Duration(days: 7 - today.weekday));
                                  context.read<FetchDailyStreakBloc>().add(
                                      FetchDailyStreakEvent(
                                          startDate: mondayBefore,
                                          endDate: sundayAfter));
                                  context
                                      .read<HomeBloc>()
                                      .add(const GetHomeEvent(refresh: true));
                                  context
                                      .read<FetchDailyQuizBloc>()
                                      .add(const FetchDailyQuizEvent());
                                },
                              ),
                            );
                          } else {
                            return Container();
                            // return Container(
                            //   child: Column(
                            //     children: [],
                            //   ),
                            // );
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 2.5.h),
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.only(
                                      left: 4.w, top: 3.h, bottom: 3.h),
                                  decoration: BoxDecoration(
                                      color: const Color(0xff18786a),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: BlocBuilder<HomeBloc, HomeState>(
                                    builder: (context, state) {
                                      if (state is GetHomeState &&
                                          state.status == HomeStatus.loaded) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              state.lastStartedChapter == null
                                                  ? AppLocalizations.of(
                                                          context)!
                                                      .first_lesson
                                                  : AppLocalizations.of(
                                                          context)!
                                                      .continue_studying,
                                              maxLines: 2,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(height: 1.h),
                                            Text(
                                              state.lastStartedChapter == null
                                                  ? ''
                                                  : state.lastStartedChapter!
                                                      .courseName,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300,
                                              ),
                                              maxLines: 1,
                                            ),
                                            SizedBox(height: 1.h),
                                            Text(
                                              state.lastStartedChapter == null
                                                  ? AppLocalizations.of(
                                                          context)!
                                                      .first_lesson_text
                                                  : state
                                                      .lastStartedChapter!.name,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w500,
                                              ),
                                              maxLines: 2,
                                            ),
                                            SizedBox(height: 2.h),
                                            InkWell(
                                              onTap: () {
                                                if (state.lastStartedChapter ==
                                                    null) {
                                                  ChooseSubjectPageRoute(
                                                          $extra: false)
                                                      .go(context);
                                                } else {
                                                  CourseDetailPageRoute(
                                                    courseId: state
                                                        .lastStartedChapter!
                                                        .courseId,
                                                    lastStartedSubChapterId:
                                                        state
                                                            .lastStartedChapter!
                                                            .id,
                                                  ).go(context);
                                                }
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 1.h,
                                                    horizontal: 4.w),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color:
                                                      const Color(0xffffc107),
                                                ),
                                                child: Text(
                                                  state.lastStartedChapter ==
                                                          null
                                                      ? AppLocalizations.of(
                                                              context)!
                                                          .start
                                                      : AppLocalizations.of(
                                                              context)!
                                                          .continue_key,
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            )
                                          ],
                                        );
                                      } else if (state is GetHomeState &&
                                          state.status == HomeStatus.loading) {
                                        return _continueStudyingShimmer();
                                      } else {
                                        return Container();
                                      }
                                    },
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                        bottomRight: Radius.circular(20)),
                                    child: Image(
                                      image: const AssetImage(
                                          'assets/images/stackOfBooks.png'),
                                      height: 8.h,
                                      width: 13.w,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Stack(
                            children: [
                              Container(
                                width: 35.w,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 4.w, vertical: 3.h),
                                decoration: BoxDecoration(
                                    color: const Color(0xffffc107),
                                    borderRadius: BorderRadius.circular(20)),
                                child: BlocBuilder<FetchDailyQuizBloc,
                                    FetchDailyQuizState>(
                                  builder: (context, state) {
                                    if (state is FetchDailyQuizLoaded) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  AppLocalizations.of(context)!
                                                      .daily_quiz,
                                                  maxLines: 2,
                                                  style: const TextStyle(
                                                      color: Color(0xff263238),
                                                      fontSize: 18,
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              SizedBox(width: 2.w),
                                              TooltipWidget(
                                                  iconSize: 18,
                                                  message: AppLocalizations.of(
                                                          context)!
                                                      .daily_quiz_info),
                                            ],
                                          ),
                                          SizedBox(height: 2.h),
                                          Text(
                                            state.dailyQuiz.dailyQuizQuestions
                                                    .isEmpty
                                                ? 'No quiz for the day. Check back tomorrow for a new challenge!' //! this has to be changed
                                                : AppLocalizations.of(context)!
                                                    .daily_quiz_text,
                                            style: const TextStyle(
                                              color: Colors.black54,
                                            ),
                                          ),
                                          SizedBox(height: 1.h),
                                          if (state.dailyQuiz.isSolved !=
                                                  null &&
                                              state.dailyQuiz.isSolved!)
                                            Text(
                                              'Score: ${state.dailyQuiz.userScore}',
                                              style: TextStyle(
                                                color: const Color(0xff263238)
                                                    .withOpacity(.7),
                                                fontSize: 16,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          SizedBox(height: 2.h),
                                          if (state.dailyQuiz.dailyQuizQuestions
                                              .isNotEmpty)
                                            InkWell(
                                              onTap: () {
                                                // print(
                                                //     'isSolved: ${state.dailyQuiz.isSolved}');
                                                if (state.dailyQuiz.isSolved!) {
                                                  context
                                                      .read<
                                                          FetchDailyQuizForAnalysisBloc>()
                                                      .add(
                                                        FetchDailyQuizForAnalysisByIdEvent(
                                                          id: state
                                                              .dailyQuiz.id,
                                                        ),
                                                      );
                                                } else {
                                                  DailyQuizQuestionPageRoute(
                                                    $extra:
                                                        DailyQuestionPageParams(
                                                      dailyQuiz:
                                                          state.dailyQuiz,
                                                      questionMode:
                                                          QuestionMode.quiz,
                                                    ),
                                                  ).go(context);
                                                }
                                              },
                                              child: BlocBuilder<
                                                      FetchDailyQuizForAnalysisBloc,
                                                      FetchDailyQuizForAnalysisState>(
                                                  builder: (context,
                                                      fetchDailyQuizForAnalysisState) {
                                                // print(
                                                //     'Current state: $fetchDailyQuizForAnalysisState');
                                                if (fetchDailyQuizForAnalysisState
                                                    is FetchDailyQuizForAnalysisLoaded) {
                                                  DailyQuizQuestionPageRoute(
                                                    $extra:
                                                        DailyQuestionPageParams(
                                                      dailyQuiz:
                                                          fetchDailyQuizForAnalysisState
                                                              .dailyQuiz,
                                                      questionMode:
                                                          QuestionMode.analysis,
                                                    ),
                                                  ).go(context);
                                                }
                                                return Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 1.h,
                                                      horizontal: 4.w),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    color:
                                                        const Color(0xff18786a),
                                                  ),
                                                  child: (fetchDailyQuizForAnalysisState
                                                          is FetchDailyQuizForAnalysisLoading)
                                                      ? const SizedBox(
                                                          height: 10,
                                                          width: 10,
                                                          child:
                                                              CircularProgressIndicator(
                                                            color: Colors.white,
                                                            strokeWidth: 1,
                                                          ),
                                                        )
                                                      : Text(
                                                          (state.dailyQuiz.isSolved !=
                                                                      null &&
                                                                  state.dailyQuiz
                                                                          .isSolved ==
                                                                      false)
                                                              ? AppLocalizations
                                                                      .of(
                                                                          context)!
                                                                  .go
                                                              : AppLocalizations
                                                                      .of(context)!
                                                                  .analyis,
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                );
                                              }),
                                            )
                                        ],
                                      );
                                    } else if (state is FetchDailyQuizLoading) {
                                      return _dailyQuizShimmer();
                                    } else {
                                      return Container();
                                    }
                                  },
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(20)),
                                  child: Image(
                                    image: const AssetImage(
                                        'assets/images/bookFloating.png'),
                                    height: 17.h,
                                    width: 20.w,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.daily_quest,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        SizedBox(width: 2.w),
                        TooltipWidget(
                            message:
                                AppLocalizations.of(context)!.daily_quest_info)
                      ],
                    ),
                    const DailyQuestWidget(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Shimmer _dailyStreakShimmer() {
    return Shimmer.fromColors(
      direction: ShimmerDirection.ttb,
      baseColor: Colors.black,
      highlightColor: Colors.white70,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 120,
                    height: 18,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  // Container(
                  //   width: 36,
                  //   height: 18,
                  //   color: Colors.black12,
                  // ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 32,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              )
            ],
          ),
          SizedBox(height: 1.h),
          SizedBox(
            width: 100.w,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 10,
                  width: 6,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                  width: 70.w,
                  child: ListView.separated(
                    itemCount: 7,
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, index) => Container(
                      width: 4.5.w,
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.only(bottom: 32),
                      child: Container(height: 1, color: Colors.black12),
                    ),
                    itemBuilder: (context, index) => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 18,
                          height: 14,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 10,
                  width: 6,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Shimmer _continueStudyingShimmer() {
    return Shimmer.fromColors(
      direction: ShimmerDirection.ttb,
      baseColor: Colors.black,
      highlightColor: Colors.white70,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const Text(
          //   'Continue Studying',
          //   style: TextStyle(
          //     color: Colors.white,
          //     fontSize: 20,
          //     fontFamily: 'Poppins',
          //     fontWeight: FontWeight.w600,
          //   ),
          // ),
          Container(
            width: 120,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          SizedBox(height: 3.h),
          // const Text(
          //   'CHAPTER 2',
          //   style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
          // ),
          Container(
            width: 48,
            height: 16,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          SizedBox(height: 1.h),
          // const Text(
          //   'Organic molecules',
          //   style: TextStyle(
          //     color: Colors.white,
          //     fontSize: 16,
          //     fontFamily: 'Poppins',
          //     fontWeight: FontWeight.w500,
          //   ),
          // ),
          Container(
            width: 100,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            width: 80,
            height: 32,
            padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.black12,
            ),
          )
        ],
      ),
    );
  }

  Shimmer _dailyQuizShimmer() {
    return Shimmer.fromColors(
      direction: ShimmerDirection.ttb,
      baseColor: Colors.black,
      highlightColor: Colors.white70,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            width: 120,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.black12,
            ),
          )
        ],
      ),
    );
  }
}
