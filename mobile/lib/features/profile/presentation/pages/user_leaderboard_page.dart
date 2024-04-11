import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:prepgenie/core/core.dart';
import 'package:prepgenie/features/profile/presentation/bloc/usersLeaderboard/users_leaderboard_bloc.dart';
import 'package:prepgenie/features/profile/presentation/widgets/leaderboard_tab.dart';

import '../../domain/entities/user_leaderboard_entity.dart';

class UserLeaderboardPage extends StatefulWidget {
  const UserLeaderboardPage({super.key});

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
    context.read<UsersLeaderboardBloc>().add(GetTopUsersEvent(pageNumber: 1));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LeaderboardTab(),
    );
  }
}
