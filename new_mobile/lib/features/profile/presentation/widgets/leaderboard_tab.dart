import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:prep_genie/core/bloc/tokenSession/token_session_bloc.dart';
import 'package:prep_genie/core/core.dart';
import 'package:prep_genie/core/widgets/noInternet.dart';
import 'package:prep_genie/features/features.dart';
import 'package:prep_genie/features/profile/presentation/widgets/leaderboardtabs.dart';
import 'package:prep_genie/features/profile/presentation/widgets/nested_scrollLederboard_widget.dart';
import 'package:prep_genie/features/profile/presentation/widgets/top_ranked_detail_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/utils/snack_bar.dart';
import '../../domain/entities/user_leaderboard_entity.dart';
import '../bloc/usersLeaderboard/users_leaderboard_bloc.dart';
import 'leaderboard_list_card.dart';

class LeaderboardTab extends StatefulWidget {
  const LeaderboardTab({super.key});
  @override
  State<LeaderboardTab> createState() => _LeaderboardTabState();
}

class _LeaderboardTabState extends State<LeaderboardTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  double appBarExpandedHeight = 10;
  final scrollContoller = ScrollController();
  int page = 1;
  int currentTabIndex = 0;
  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  LeaderboardType getLeaderboardType({required int idx}) {
    switch (idx) {
      case 0:
        return LeaderboardType.allTime;
      case 1:
        return LeaderboardType.weekly;
      case 3:
        return LeaderboardType.monthly;
      default:
        return LeaderboardType.allTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TokenSessionBloc, TokenSessionState>(
      listener: (context, state) {
        if (state is TokenSessionExpiredState) {
          LoginPageRoute().go(context);
        }
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 2.h),
            width: 100.w,
            decoration: const BoxDecoration(
              color: Color.fromRGBO(24, 120, 106, 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${AppLocalizations.of(context)!.leaderboard} 🏆',
                  style: TextStyle(
                    color: Colors.white,
                    height: 1.5,
                    fontSize: 20.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                TabBar(
                  labelPadding: EdgeInsets.zero,
                  controller: _tabController,
                  onTap: (index) {
                    if (index == currentTabIndex) return;
                    setState(() {
                      currentTabIndex = index;
                    });
                    context.read<UsersLeaderboardBloc>().add(GetTopUsersEvent(
                        pageNumber: 1,
                        leaderboardType: getLeaderboardType(idx: index)));
                  },
                  tabs: [
                    LeaderboardTabs(
                        isActive: currentTabIndex == 0, title: 'All Time'),
                    LeaderboardTabs(
                        isActive: currentTabIndex == 1, title: 'Weekly'),
                    LeaderboardTabs(
                        isActive: currentTabIndex == 2, title: 'Monthly'),
                  ],
                  dividerColor: const Color(0xFF0072FF).withOpacity(.5),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.white,
                  unselectedLabelColor:
                      const Color.fromARGB(255, 224, 219, 219),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<UsersLeaderboardBloc, UsersLeaderboardState>(
              builder: (context, state) {
                if (state is UsersLeaderboardFailedState) {
                  if (state.failure is NetworkFailure) {
                    return NoInternet(
                      reloadCallback: () {
                        context.read<UsersLeaderboardBloc>().add(
                              const GetTopUsersEvent(
                                  pageNumber: 1,
                                  leaderboardType: LeaderboardType.allTime),
                            );
                      },
                    );
                  } else if (state.failure is AuthenticationFailure) {
                    return const Center(child: SessionExpireAlert());
                  }
                  return const Center(
                    child: Text('Unkown Error happend'),
                  );
                } else if (state is UsersLeaderboardLoadingState) {
                  return _LeaderboardLoadingShimmer();
                } else if (state is UsersLeaderboardNextPageLoadingState) {
                  List<UserLeaderboardEntity> topUsers =
                      state.previousLeaderboard.userLeaderboardEntities;
                  if (topUsers.isEmpty || topUsers.length < 3) {
                    return const EmptyListWidget(message: 'Comeback soon');
                  }
                  return NestedScrollableLeaderboardWidget(
                    loading: true,
                    topUsers: topUsers,
                    userRank: state.previousLeaderboard.userRank,
                    leaderboardTab: currentTabIndex,
                  );
                } else if (state is UsersLeaderboardLoadedState) {
                  List<UserLeaderboardEntity> topUsers =
                      state.topUsers.userLeaderboardEntities;
                  if (topUsers.isEmpty || topUsers.length < 3) {
                    return const EmptyListWidget(message: 'Comeback soon');
                  }
                  return NestedScrollableLeaderboardWidget(
                    loading: false,
                    topUsers: topUsers,
                    userRank: state.topUsers.userRank,
                    leaderboardTab: currentTabIndex,
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }

  Shimmer _LeaderboardLoadingShimmer() {
    return Shimmer.fromColors(
        direction: ShimmerDirection.ltr,
        baseColor: const Color.fromARGB(255, 236, 235, 235),
        highlightColor: const Color(0xffF9F8F8),
        child: Column(
          children: [
            SizedBox(height: 4.h),
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    LeaderboardShimmer(size: 80, ringSize: 20),
                    LeaderboardShimmer(size: 120, ringSize: 25),
                    LeaderboardShimmer(size: 90, ringSize: 22),
                  ],
                ),
              ],
            ),
            SizedBox(height: 6.h),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) => Row(
                    children: [
                      SizedBox(width: 2.w),
                      Container(
                        width: 5.w,
                        height: 2.h,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      SizedBox(width: 3.w),
                      Container(
                        height: 6.h,
                        width: 6.h,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 2.h,
                            width: 55.w,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star),
                              SizedBox(width: 1.w),
                              Container(
                                height: 1.5.h,
                                width: 15.w,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: 6,
                ),
              ),
            ),
          ],
        ));
  }

  Column LeaderboardShimmer({required double size, required double ringSize}) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              padding: EdgeInsets.only(top: 2.h),
              child: Container(
                height: size,
                width: size,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              height: ringSize,
              width: ringSize,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.white),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Container(
          height: 3.h,
          width: 30.w,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
        ),
        SizedBox(height: 1.5.h),
        Container(
          height: 3.h,
          width: 12.w,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
        ),
        SizedBox(height: 1.5.h),
        Container(
          height: 2.h,
          width: 25.w,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
        )
      ],
    );
  }
}
