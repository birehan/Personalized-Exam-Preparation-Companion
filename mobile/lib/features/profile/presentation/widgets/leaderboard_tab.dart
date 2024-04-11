import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:prepgenie/core/bloc/tokenSession/token_session_bloc.dart';
import 'package:prepgenie/core/core.dart';
import 'package:prepgenie/core/widgets/noInternet.dart';
import 'package:prepgenie/features/features.dart';
import 'package:prepgenie/features/profile/presentation/widgets/nested_scrollLederboard_widget.dart';
import 'package:prepgenie/features/profile/presentation/widgets/top_ranked_detail_card.dart';

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
  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TokenSessionBloc, TokenSessionState>(
      listener: (context, state) {
        if (state is TokenSessionExpiredState) {
          LoginPageRoute().go(context);
        }
      },
      child: BlocBuilder<UsersLeaderboardBloc, UsersLeaderboardState>(
        builder: (context, state) {
          if (state is UsersLeaderboardFailedState) {
            if (state.failure is NetworkFailure) {
              return NoInternet(
                reloadCallback: () {
                  context.read<UsersLeaderboardBloc>().add(
                        const GetTopUsersEvent(pageNumber: 1),
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
            );
          }
          return Container();
        },
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
            SizedBox(height: 2.h),
            Column(
              children: [
                Container(
                  height: 4.h,
                  width: 50.w,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                ),
                SizedBox(height: 4.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    LeaderboardShimmer(size: 80),
                    LeaderboardShimmer(size: 120),
                    LeaderboardShimmer(size: 90),
                  ],
                ),
                SizedBox(height: 2.h),
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

  Column LeaderboardShimmer({required double size}) {
    return Column(
      children: [
        Container(
          height: size,
          width: size,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          height: 3.h,
          width: 30.w,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
        ),
        SizedBox(height: 2.h),
        Container(
          height: 4.h,
          width: 8.w,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
        ),
        SizedBox(height: 2.h),
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
