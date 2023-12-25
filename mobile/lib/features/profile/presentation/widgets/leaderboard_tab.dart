import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skill_bridge_mobile/core/core.dart';
import 'package:skill_bridge_mobile/core/widgets/noInternet.dart';
import 'package:skill_bridge_mobile/features/profile/presentation/widgets/top_ranked_detail_card.dart';

import '../../domain/entities/user_leaderboard_entity.dart';
import '../bloc/usersLeaderboard/users_leaderboard_bloc.dart';
import 'leaderboard_list_card.dart';

class LeaderboardTab extends StatelessWidget {
  final UserLeaderboardEntity currentUser;
  const LeaderboardTab({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocBuilder<UsersLeaderboardBloc, UsersLeaderboardState>(
        builder: (context, state) {
          if (state is UsersLeaderboardFailedState) {
            if (state.failure is NetworkFailure) {
              return NoInternet(
                reloadCallback: () {
                  context.read<UsersLeaderboardBloc>().add(GetTopUsersEvent());
                },
              );
            } else {
              return const Center(child: Text('Unknown Error happened'));
            }
          } else if (state is UsersLeaderboardLoadingState) {
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomProgressIndicator(),
              ],
            );
          } else if (state is UsersLeaderboardLoadedState) {
            List<UserLeaderboardEntity> topUsers = state.topUsers;
            if (topUsers.isEmpty || topUsers.length < 3) {
              return const EmptyListWidget(message: 'Comeback soon');
            }

            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TopRankedDetail(
                        diameter: 22.w,
                        color: const Color(0xff1C85E8),
                        badgeDiameter: 3.h,
                        rank: 2,
                        imageUrl: topUsers[0].userAvatar,
                        name:
                            '${topUsers[1].firstName} ${topUsers[1].lastName}',
                        point: topUsers[1].overallPoints),
                    TopRankedDetail(
                        diameter: 30.w,
                        color: const Color(0xffFFC107),
                        badgeDiameter: 4.h,
                        rank: 1,
                        imageUrl: topUsers[0].userAvatar,
                        name:
                            '${topUsers[0].firstName} ${topUsers[0].lastName}',
                        point: topUsers[0].overallPoints),
                    TopRankedDetail(
                        diameter: 20.w,
                        color: const Color(0xffF7A9A0),
                        badgeDiameter: 3.h,
                        rank: 3,
                        imageUrl: topUsers[2].userAvatar,
                        name:
                            '${topUsers[2].firstName} ${topUsers[2].lastName}',
                        point: topUsers[2].overallPoints),
                  ],
                ),
                SizedBox(height: 2.h),
                LeaderboardListCard(
                  userData: true,
                  name: '${currentUser.firstName} ${currentUser.lastName}',
                  imageUrl: currentUser.userAvatar,
                  points: currentUser.overallPoints,
                  rank: currentUser.overallRank,
                ),
                SizedBox(height: 1.h),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => LeaderboardListCard(
                    userData: false,
                    imageUrl: topUsers[index + 3].userAvatar,
                    name:
                        '${topUsers[index + 3].firstName} ${topUsers[index + 3].lastName}',
                    points: topUsers[index + 3].overallPoints,
                    rank: index + 4,
                  ),
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: topUsers.length - 3,
                )
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}
