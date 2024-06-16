import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:prep_genie/core/widgets/progress_indicator.dart';
import 'package:prep_genie/features/profile/domain/entities/user_leaderboard_entity.dart';
import 'package:prep_genie/features/profile/domain/entities/user_leaderboard_rank.dart';
import 'package:prep_genie/features/profile/presentation/bloc/usersLeaderboard/users_leaderboard_bloc.dart';
import 'package:prep_genie/features/profile/presentation/widgets/leaderboard_list_card.dart';
import 'package:prep_genie/features/profile/presentation/widgets/top_ranked_detail_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NestedScrollableLeaderboardWidget extends StatefulWidget {
  const NestedScrollableLeaderboardWidget({
    super.key,
    required this.topUsers,
    required this.userRank,
    required this.loading,
    required this.leaderboardTab,
  });

  final List<UserLeaderboardEntity> topUsers;
  final UserLeaderboardRank? userRank;
  final bool loading;
  final int leaderboardTab;

  @override
  State<NestedScrollableLeaderboardWidget> createState() =>
      _NestedScrollableLeaderboardWidgetState();
}

class _NestedScrollableLeaderboardWidgetState
    extends State<NestedScrollableLeaderboardWidget> {
  int page = 1;
  @override
  void initState() {
    super.initState();
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
    bool onNotification(ScrollEndNotification t) {
      if (t.metrics.pixels > 0 &&
          t.metrics.atEdge &&
          context.read<UsersLeaderboardBloc>().state
              is! UsersLeaderboardLoadingState &&
          context.read<UsersLeaderboardBloc>().state
              is! UsersLeaderboardNextPageLoadingState) {
        page = page + 1;
        context.read<UsersLeaderboardBloc>().add(
              GetTopUsersEvent(
                  pageNumber: page,
                  leaderboardType:
                      getLeaderboardType(idx: widget.leaderboardTab)),
            );
      }
      return true;
    }

    return NotificationListener(
      onNotification: onNotification,
      child: NestedScrollView(
        // controller: scrollContoller,
        // physics: const BouncingScrollPhysics(parent: FixedExtentScrollPhysics()),

        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: const Color(0xFF18786C),
              // pinned: true,
              // centerTitle: true,
              expandedHeight: 35.h,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  // height: 45.h,
                  padding: EdgeInsets.only(bottom: 2.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        const Color(0xFF18786C).withOpacity(.8),
                        const Color(0xff18786c),
                      ],
                    ),
                  ),
                  // padding: EdgeInsets.only(top: 2.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TopRankedDetail(
                        userId: widget.topUsers[1].userId,
                        diameter: 20.w,
                        color: const Color(0xffb3c1c9),
                        badgeDiameter: 3.h,
                        rank: 2,
                        imageUrl: widget.topUsers[1].userAvatar,
                        name:
                            '${widget.topUsers[1].firstName} ${widget.topUsers[1].lastName}',
                        point: widget.topUsers[1].overallPoints,
                      ),
                      TopRankedDetail(
                        userId: widget.topUsers[0].userId,
                        diameter: 28.w,
                        color: const Color(0xFFffcf3f),
                        // color: const Color(0xffFFC107),
                        badgeDiameter: 4.h,
                        rank: 1,
                        imageUrl: widget.topUsers[0].userAvatar,
                        name:
                            '${widget.topUsers[0].firstName} ${widget.topUsers[0].lastName}',
                        point: widget.topUsers[0].overallPoints,
                      ),
                      TopRankedDetail(
                        userId: widget.topUsers[2].userId,
                        diameter: 20.w,
                        color: const Color(0xFFd4a96b),
                        badgeDiameter: 3.h,
                        rank: 3,
                        imageUrl: widget.topUsers[2].userAvatar,
                        name:
                            '${widget.topUsers[2].firstName} ${widget.topUsers[2].lastName}',
                        point: widget.topUsers[2].overallPoints,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (widget.userRank != null)
              SliverAppBar(
                pinned: true,
                collapsedHeight: 10.h,
                flexibleSpace: Stack(
                  children: [
                    // const FlexibleSpaceBar(),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: LeaderboardListCard(
                        userId: widget.userRank!.id,
                        index: widget.userRank!.rank,
                        userData: false,
                        imageUrl: widget.userRank!.avatar,
                        name:
                            '${widget.userRank!.firstName} ${widget.userRank!.lastName}',
                        points: widget.userRank!.points,
                        rank: widget.userRank!.rank + 1,
                        contestAttended: widget.userRank!.contestAttended,
                        maxStreak: widget.userRank!.maxStreak,
                        isMyRank: true,
                      ),
                    ),
                  ],
                ),
              ),
          ];
        },
        body: CustomScrollView(
          // physics: const NeverScrollableScrollPhysics(),
          // controller: scrollContoller,
          shrinkWrap: true,
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return LeaderboardListCard(
                    userId: widget.topUsers[index + 3].userId,
                    index: index,
                    userData: false,
                    imageUrl: widget.topUsers[index + 3].userAvatar,
                    name:
                        '${widget.topUsers[index + 3].firstName} ${widget.topUsers[index + 3].lastName}',
                    points: widget.topUsers[index + 3].overallPoints,
                    rank: index + 4,
                    contestAttended: widget.topUsers[index + 3].contestAttended,
                    maxStreak: widget.topUsers[index + 3].maxStreak,
                  );
                },
                childCount: widget.topUsers.length - 3,
              ),
            ),
            if (widget.loading)
              const SliverToBoxAdapter(
                child: Center(
                  child: SizedBox(
                    child: CustomProgressIndicator(
                      size: 30,
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
