// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skill_bridge_mobile/core/bloc/tokenSession/token_session_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/core.dart';
import '../../../../core/utils/snack_bar.dart';
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
    context.read<HomeBloc>().add(GetHomeEvent(refresh: false));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    FirebaseAnalytics.instance.setCurrentScreen(screenName: 'Home Page');
  }

  bool showAlertDialog = false;
  final NetworkInfo networkInfo =
      NetworkInfoImpl(internetConnectionChecker: InternetConnectionChecker());
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FF),
      body: BlocListener<TokenSessionBloc, TokenSessionState>(
        listener: (_, state) {
          if (state is TokenSessionExpiredState) {
            LoginPageRoute().go(context);
          }
        },
        child: Padding(
          padding: EdgeInsets.only(top: 3.h),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: RefreshIndicator(
              onRefresh: () async {
                if (await networkInfo.isConnected) {
                  context.read<HomeBloc>().add(GetHomeEvent(refresh: true));
                  return;
                }

                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                final snackBar =
                    SnackBar(content: Text(AppLocalizations.of(context)!.you_are_not_connected));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    const UpdatedHeaderWidget(),
                    BlocListener<HomeBloc, HomeState>(
                      listener: (context, state) {
                        if (state is GetHomeState &&
                            state.status == HomeStatus.error) {
                          if (state.failure is RequestOverloadFailure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                snackBar(state.failure!.errorMessage));
                          }
                        }
                      },
                      child: BlocBuilder<HomeBloc, HomeState>(
                        builder: (context, state) {
                          if (state is GetHomeState &&
                              state.status == HomeStatus.error) {
                            if (state.failure is NetworkFailure) {
                              return NoInternet(
                                reloadCallback: () {
                                  context
                                      .read<HomeBloc>()
                                      .add(GetHomeEvent(refresh: true));
                                },
                              );
                            } else if (state.failure is AuthenticationFailure) {
                              return SessionExpireAlert();
                              // WidgetsBinding.instance.addPostFrameCallback((_) {
                              // Future.microtask(() {
                              //   showDialog(
                              //       context: context,
                              //       builder: (context) => SessionExpireAlert());
                              // });
                              // });
                            }
                            return Center(child: Text(AppLocalizations.of(context)!.unkown_error_happend));
                          } else {
                            return Column(
                              children: [
                                SizedBox(height: 4.h),
                                TakeLessonCard(width: width, height: height),
                                SizedBox(height: 4.h),
                                RecommendedMocksWidget(
                                  // stream: state.userCredential!.department!,
                                  stream: 'Natural Science',
                                )
                              ],
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
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
