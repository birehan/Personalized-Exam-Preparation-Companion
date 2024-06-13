import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:shimmer/shimmer.dart';

import 'package:prep_genie/core/widgets/noInternet.dart';
import 'package:prep_genie/features/profile/presentation/bloc/barChartBloc/bar_chart_bloc.dart';
import 'package:prep_genie/features/profile/presentation/bloc/consistancyBloc/consistancy_bloc_bloc.dart';
import 'package:prep_genie/features/profile/presentation/bloc/schoolInfoBloc/school_bloc.dart';
import 'package:prep_genie/features/profile/presentation/bloc/userProfile/userProfile_bloc.dart';
import 'package:prep_genie/features/profile/presentation/bloc/userProfile/userProfile_event.dart';
import 'package:prep_genie/features/profile/presentation/bloc/userProfile/userProfile_state.dart';
import 'package:prep_genie/features/profile/presentation/widgets/updadted_profile_overview_widget.dart';
import 'package:prep_genie/features/profile/presentation/widgets/updated_profile_header.dart';
import 'package:prep_genie/features/profile/presentation/widgets/updated_user_records.dart';


class UpdatedProfilePage extends StatefulWidget {
  const UpdatedProfilePage({super.key});

  @override
  State<UpdatedProfilePage> createState() => _UpdatedProfilePageState();
}

class _UpdatedProfilePageState extends State<UpdatedProfilePage> {
  int curYear = DateTime.now().year;
  double _value = 0;
  double time = 2;
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    BlocProvider.of<UserProfileBloc>(context).add(
      GetUserProfile(isRefreshed: true),
    );
    context.read<ConsistancyBlocBloc>().add(GetUserConsistencyDataEvent(
          year: curYear.toString(),
        ));
    context.read<SchoolBloc>().add(GetSchoolInformationEvent());
    context.read<BarChartBloc>().add(GetBarChartDataEvent());
    // _startTimer();
  }

  @override
  void dispose() {
    // _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        time--;
        if (time == 0) {
          _timer?.cancel();
          setState(() {
            _value = 57;
          });
        }
      });
    });
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
      'Dec'
    ];
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
                onPressed: () {
                  context.pop();
                },
                icon: const Icon(Icons.arrow_back_sharp)),
            Padding(
              padding: EdgeInsets.only(right: 5.w, left: 7.w),
              child: Column(
                children: [
                  BlocBuilder<UserProfileBloc, UserProfileState>(
                    builder: (context, state) {
                      if (state is ProfileFailedState) {
                        return SizedBox(
                          height: 50.h,
                          child: Center(
                            child: NoInternet(reloadCallback: () {
                              BlocProvider.of<UserProfileBloc>(context).add(
                                GetUserProfile(isRefreshed: true),
                              );
                              context
                                  .read<ConsistancyBlocBloc>()
                                  .add(GetUserConsistencyDataEvent(
                                    year: curYear.toString(),
                                  ));
                              context
                                  .read<SchoolBloc>()
                                  .add(GetSchoolInformationEvent());
                            }),
                          ),
                        );
                      } else if (state is ProfileLoading) {
                        return _updatedProfilePageTopShimmer();
                      } else if (state is ProfileLoaded) {
                        final user = state.userProfile;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ProfileHeader(
                              firstName: user.firstName,
                              lastName: user.lastName,
                              grade: user.grade,
                              avatar: user.profileImage,
                            ),
                            SizedBox(height: 3.h),
                            SizedBox(height: 2.h),
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
                              ],
                            ),
                            SizedBox(height: 2.h),
                            OverviewWidget(
                              chapterNum: user.chaptersCompleted,
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
                  SizedBox(height: 3.h),
                  SizedBox(height: 3.h),
                ],
              ),
            ),
          ],
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
          Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                      ),
                      Container(
                        height: 2.h,
                        width: 30.w,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
                SizedBox(width: 2.w),
                Container(
                  height: 3.h,
                  width: 1,
                  color: Colors.white,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Container(
                    width: 40.w,
                    height: 2.h,
                    color: Colors.white,
                  ),
                )
              ],
            ),
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
                        imageColor: Colors.green,
                        imagePath: 'assets/images/askQuestion.png',
                        number: 12,
                        text: 'Questions Solved'),
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
