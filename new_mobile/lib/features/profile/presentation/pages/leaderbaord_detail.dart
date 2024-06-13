import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:prep_genie/core/core.dart';
import 'package:prep_genie/core/widgets/tooltip_widget.dart';
import 'package:prep_genie/features/profile/domain/entities/consistency_entity.dart';
import 'package:prep_genie/features/profile/presentation/bloc/consistancyBloc/consistancy_bloc_bloc.dart';
import 'package:prep_genie/features/profile/presentation/bloc/schoolInfoBloc/school_bloc.dart';
import 'package:prep_genie/features/profile/presentation/bloc/userProfile/userProfile_bloc.dart';
import 'package:prep_genie/features/profile/presentation/bloc/userProfile/userProfile_event.dart';
import 'package:prep_genie/features/profile/presentation/bloc/userProfile/userProfile_state.dart';
import 'package:prep_genie/features/profile/presentation/widgets/conststency_tracking_calender_widget.dart';
import 'package:prep_genie/features/profile/presentation/widgets/leaderboard_detail_header.dart';
import 'package:prep_genie/features/profile/presentation/widgets/updadted_profile_overview_widget.dart';
import 'package:prep_genie/features/profile/presentation/widgets/updated_profile_header.dart';
import 'package:prep_genie/features/profile/presentation/widgets/updated_profile_stat_card.dart';
import 'package:prep_genie/features/profile/presentation/widgets/updated_profile_stat_card_leaderboard.dart';
import 'package:prep_genie/features/profile/presentation/widgets/updated_user_records.dart';

import '../../../../core/utils/snack_bar.dart';

class LeaderboardDetailPage extends StatefulWidget {
  final String userId;
  const LeaderboardDetailPage({super.key, required this.userId});

  @override
  State<LeaderboardDetailPage> createState() => _LeaderboardDetailPageState();
}

class _LeaderboardDetailPageState extends State<LeaderboardDetailPage> {
  int curYear = DateTime.now().year;
  @override
  void initState() {
    super.initState();
    BlocProvider.of<UserProfileBloc>(context).add(
      GetUserProfile(
        isRefreshed: true,
        userId: widget.userId,
      ),
    );
    context.read<ConsistancyBlocBloc>().add(GetUserConsistencyDataEvent(
          year: curYear.toString(),
          userId: widget.userId,
        ));
    context.read<SchoolBloc>().add(GetSchoolInformationEvent());
  }

  @override
  Widget build(BuildContext context) {
    final List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 5.h, right: 5.w, left: 7.w),
          child: Column(
            children: [
              BlocBuilder<UserProfileBloc, UserProfileState>(
                builder: (context, state) {
                  if (state is ProfileFailedState) {
                    return const Text('failed to load profile');
                  } else if (state is ProfileLoading) {
                    return _updatedProfilePageTopShimmer();
                  } else if (state is ProfileLoaded) {
                    final user = state.userProfile;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LeaderbordDetailHeader(
                          firstName: user.firstName,
                          lastName: user.lastName,
                          grade: user.grade,
                          avatar: user.profileImage,
                        ),
                        SizedBox(height: 3.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            LeaderboardProfileStatCard(
                                width: 26.w,
                                number: user.maxStreak.toString(),
                                title: 'STREAK',
                                isForPoint: false),
                            LeaderboardProfileStatCard(
                                width: 30.w,
                                number: user.points.ceil().toString(),
                                title: 'POINTS',
                                isForPoint: true),
                            LeaderboardProfileStatCard(
                                width: 26.w,
                                number: user.rank.toString(),
                                title: 'RANK',
                                isForPoint: false),
                          ],
                        ),
                        SizedBox(height: 3.h),
                        Row(
                          children: [
                            const Text(
                              'Overview',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            // const TooltipWidget(
                            //     iconSize: 18,
                            //     message:
                            //         'Long message No quiz for the day. Check back tomorrow for a new challenge!'),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        OverviewWidget(
                          chapterNum: user.chaptersCompleted,
                          // points: user.points.toDouble(),
                          questionsNum: user.questionsSolved,
                          topicsNum: user.topicsCompleted,
                        ),
                        SizedBox(height: 3.h),
                      ],
                    );
                  }
                  return Container();
                },
              ),
              BlocListener<ConsistancyBlocBloc, ConsistancyBlocState>(
                listener: (context, state) {
                  if (state is ConsistancyFailedState) {
                    if (state.failureType is RequestOverloadFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          snackBar(state.failureType.errorMessage));
                    }
                  }
                },
                child: BlocBuilder<ConsistancyBlocBloc, ConsistancyBlocState>(
                  builder: (context, state) {
                    if (state is ConsistancyLoadingState) {
                      return _updatedProfilePageBottomShimmer();
                    } else if (state is ConsistancyFailedState) {
                      return const Text('failed to laod consistency data');
                    } else if (state is ConsistancyLoadedState) {
                      final consistencyData = state.consistencyData;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Text('Consistency Chart',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      )),
                                  SizedBox(width: 2.w),
                                  const TooltipWidget(
                                      iconSize: 18,
                                      message:
                                          'Monitor and Visualize the total number of questions you solved and topics you completed each day.'),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        final year =
                                            consistencyData[0][0].day.year - 1;
                                        context.read<ConsistancyBlocBloc>().add(
                                              GetUserConsistencyDataEvent(
                                                  year: year.toString(),
                                                  userId: widget.userId),
                                            );
                                      },
                                      icon: const Icon(
                                        Icons.keyboard_arrow_left,
                                      )),
                                  Text(consistencyData[0][0]
                                      .day
                                      .year
                                      .toString()),
                                  IconButton(
                                      onPressed: () {
                                        if (consistencyData[0][0].day.year ==
                                            curYear) return;
                                        final year =
                                            consistencyData[0][0].day.year + 1;
                                        context.read<ConsistancyBlocBloc>().add(
                                            GetUserConsistencyDataEvent(
                                                year: year.toString(),
                                                userId: widget.userId));
                                      },
                                      icon: Icon(Icons.keyboard_arrow_right,
                                          color:
                                              consistencyData[0][0].day.year ==
                                                      curYear
                                                  ? Colors.grey
                                                  : null))
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          SizedBox(
                            height: 35.h,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                List<ConsistencyEntity> monthData =
                                    consistencyData[index];

                                return ConsistencyTrackingCalenderWidget(
                                  month: months[index],
                                  numOfDays: monthData.length,
                                  consistencyData: monthData,
                                );
                              },
                              separatorBuilder: (context, index) {
                                return SizedBox(width: 3.w);
                              },
                              itemCount: 12,
                            ),
                          ),
                        ],
                      );
                    }
                    return Container();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Shimmer _updatedProfilePageTopShimmer() {
    return Shimmer.fromColors(
      direction: ShimmerDirection.ltr,
      baseColor: const Color.fromARGB(255, 236, 235, 235),
      highlightColor: const Color(0xffF9F8F8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                height: 110,
                width: 110,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 3.h,
                      width: 40.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white),
                    ),
                    SizedBox(height: .5.h),
                    Container(
                      height: 2.h,
                      width: 20.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 2.w),
              const Icon(
                Icons.logout,
                color: Colors.white54,
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 26.w,
                height: 6.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
              ),
              Container(
                width: 30.w,
                height: 6.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
              ),
              Container(
                width: 26.w,
                height: 6.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Container(
            width: 30.w,
            height: 3.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.white),
          ),
          SizedBox(height: 2.h),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: UpdatedSingleRecordCard(
                        imageColor: Colors.orange,
                        imagePath: 'assets/images/Book.png',
                        number: 12,
                        text: 'Chapters Completed'),
                  ),
                  SizedBox(width: 2.w),
                  const Expanded(
                    child: UpdatedSingleRecordCard(
                        imageColor: Colors.purple,
                        imagePath: 'assets/images/Star.png',
                        number: 12,
                        text: 'Points'),
                  ),
                ],
              ),
              SizedBox(height: 3.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: UpdatedSingleRecordCard(
                        imageColor: Colors.grey,
                        imagePath: 'assets/images/Overview.png',
                        number: 12,
                        text: 'Topics Completed'),
                  ),
                  SizedBox(width: 2.w),
                  const Expanded(
                    child: UpdatedSingleRecordCard(
                        imageColor: Colors.green,
                        imagePath: 'assets/images/askQuestion.png',
                        number: 12,
                        text: 'Questions Solved'),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 3.h),
        ],
      ),
    );
  }

  Shimmer _updatedProfilePageBottomShimmer() {
    return Shimmer.fromColors(
      direction: ShimmerDirection.ltr,
      baseColor: const Color.fromARGB(255, 236, 235, 235),
      highlightColor: const Color(0xffF9F8F8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 35.w,
                height: 2.5.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.keyboard_arrow_left)),
                  Container(
                    width: 12.w,
                    height: 2.5.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.keyboard_arrow_right))
                ],
              ),
            ],
          ),
          SizedBox(height: 1.h),
          SizedBox(
            height: 35.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => SizedBox(width: 3.w),
              itemCount: 3,
              itemBuilder: (context, index) => SizedBox(
                height: 27.h,
                width: 25.w,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                  ),
                  itemCount: 30,
                  itemBuilder: (context, index) {
                    Color cellColor = Colors.white;

                    return Container(
                      height: 14,
                      width: 14,
                      margin: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: cellColor,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
