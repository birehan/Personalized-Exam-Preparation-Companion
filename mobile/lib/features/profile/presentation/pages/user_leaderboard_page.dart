import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skill_bridge_mobile/features/profile/presentation/widgets/leaderboard_tab.dart';

import '../../domain/entities/user_leaderboard_entity.dart';

class UserLeaderboardPage extends StatefulWidget {
  final UserLeaderboardEntity userInformations;
  const UserLeaderboardPage({super.key, required this.userInformations});

  @override
  State<UserLeaderboardPage> createState() => _UserLeaderboardPageState();
}

class _UserLeaderboardPageState extends State<UserLeaderboardPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 3.h, left: 8.w, right: 6.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Leaderboard 🏆',
                  style: TextStyle(
                    height: 1.5,
                    fontSize: 23.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Check out where you stand on the leaderboard.',
                  style: TextStyle(
                    color: const Color(0xff4D4B4B).withOpacity(.8),
                    fontFamily: 'Poppins',
                    fontSize: 17.sp,
                    height: 1,
                  ),
                ),
                SizedBox(height: 4.h),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
            child: SizedBox(
              width: 70.w,
              child: TabBar(
                indicatorColor: const Color(0xff18786a),
                labelColor: Colors.black,
                labelStyle: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                splashBorderRadius: BorderRadius.circular(40),
                unselectedLabelColor: Colors.grey,
                controller: _tabController,
                tabs: const [
                  Tab(text: 'All Time'),
                  Tab(text: 'Weekly'),
                  Tab(
                    text: 'Monthly',
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                LeaderboardTab(currentUser: widget.userInformations),
                // LeaderboardTab(currentUser: widget.userInformations),
                // LeaderboardTab(currentUser: widget.userInformations)
              ],
            ),
          )
        ],
      ),
    );
  }
}
