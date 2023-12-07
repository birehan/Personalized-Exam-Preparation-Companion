// ignore_for_file: prefer_const_constructors

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/core.dart';
import '../../../../core/widgets/noInternet.dart';
import '../../../features.dart';

class UpdatedHomePage extends StatefulWidget {
  final VoidCallback navigateToSettings;

  const UpdatedHomePage({
    super.key,
    required this.navigateToSettings,
  });

  @override
  State<UpdatedHomePage> createState() => _UpdatedHomePageState();
}

class _UpdatedHomePageState extends State<UpdatedHomePage> {
  @override
  void initState() {
    super.initState();
    context.read<GetUserBloc>().add(GetUserCredentialEvent());
    // context.read<MyMocksBloc>().add(GetMyMocksEvent());
    context.read<HomeBloc>().add(GetHomeEvent());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    FirebaseAnalytics.instance.setCurrentScreen(screenName: 'Home Page');
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FF),
      body: Padding(
        padding: EdgeInsets.only(top: 3.h),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const UpdatedHeaderWidget(),
                BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    if (state is GetHomeState &&
                        state.status == HomeStatus.error &&
                        state.failure is NetworkFailure) {
                      return NoInternet(
                        reloadCallback: () {
                          context.read<HomeBloc>().add(GetHomeEvent());
                        },
                      );
                    } else {
                      return Column(
                        children: [
                          SizedBox(height: 4.h),
                          TakeLessonCard(width: width, height: height),
                          SizedBox(height: 4.h),
                          BlocBuilder<GetUserBloc, GetUserState>(
                            builder: (context, state) {
                              if (state is GetUserCredentialState &&
                                  state.status == GetUserStatus.loaded) {
                                return RecommendedMocksWidget(
                                  stream: state.userCredential!.department!,
                                );
                              }
                              return Container();
                            },
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TimeCounterWidget extends StatelessWidget {
  const TimeCounterWidget({
    super.key,
    required this.countDownTime,
    required this.timeFormat,
  });

  final String countDownTime;
  final String timeFormat;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          countDownTime,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          timeFormat.toUpperCase(),
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
