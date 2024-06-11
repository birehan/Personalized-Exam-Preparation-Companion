import 'dart:math';

import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:prep_genie/core/constants/app_images.dart';
import 'package:prep_genie/core/utils/connectivity_service.dart';
import 'package:prep_genie/core/widgets/coming_soon_page.dart';
import 'package:prep_genie/core/widgets/doubleback.dart';
import 'package:prep_genie/core/widgets/dragable.dart';
import 'package:prep_genie/features/contest/presentation/pages/contests_main_page.dart';
import '../../features/features.dart';
import '../core.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, this.index});
  final String? index;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late PageController _pageController;
  late int _currentIndex;

  final bool _isDragging = false;

  bool isOfflineWidgetShown = true;
  int tabIndex = 0;
  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index != null ? int.parse(widget.index!) : 2;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _navigateToSettings() {
    setState(() {
      _currentIndex = 2; // Set the index of SettingsPage
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  void removeOfflineWidget() {
    setState(() {
      isOfflineWidgetShown = false;
    });
  }

  void goToDownloadedCourses() {
    setState(() {
      tabIndex = 2;
      _currentIndex = 1;
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
    removeOfflineWidget();
  }

  void goToDownloadedMocks() {
    setState(() {
      _currentIndex = 3;
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
    DownloadedMockExamsPageRoute().go(context);
    removeOfflineWidget();
  }

  @override
  Widget build(BuildContext context) {
    var isOffline = !context.watch<ConnectivityService>().isOnline;
    if (!isOffline) {
      isOfflineWidgetShown = true;
    }

    return DoubleBack(
      message: 'double click to exit the app',
      child: Scaffold(
        body: Stack(
          children: [
            PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                const ContestsMainPage(),
                MyCoursesPage(tabIndex: tabIndex),
                const DynamicHomePage(),
                const ExamsPage(),
                // const UserLeaderboardPage(),
              ],
            ),
            if ((isOfflineWidgetShown == isOffline) && isOffline)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: GoToDownloadsWidget(
                  removeWidget: removeOfflineWidget,
                  goToCourses: goToDownloadedCourses,
                  goToMock: goToDownloadedMocks,
                ),
              ),
          ],
        ),
        bottomNavigationBar: CircleNavBar(
          activeIcons: const [
            ActiveBttomNavWidget(icon: contestIcon),
            ActiveBttomNavWidget(icon: courseIcon),
            ActiveBttomNavWidget(icon: homeIcon),
            ActiveBttomNavWidget(icon: examsIcon),
            // ActiveBttomNavWidget(icon: leaderboardIcon),
          ],
          inactiveIcons: [
            const BottomNavCard(icon: contestIcon, text: "Recommended"),
            // AppLocalizations.of(context)!.contest),
            BottomNavCard(
                icon: courseIcon, text: AppLocalizations.of(context)!.courses),
            BottomNavCard(
                icon: homeIcon, text: AppLocalizations.of(context)!.home),
            BottomNavCard(
                icon: examsIcon, text: AppLocalizations.of(context)!.exams),
            // BottomNavCard(
            //     icon: leaderboardIcon,
            //     text: AppLocalizations.of(context)!.leaderboard),
          ],
          color: Colors.white,
          height: 8.h,
          circleWidth: 8.h,
          activeIndex: _currentIndex,
          onTap: (index) {
            _currentIndex = index;
            _pageController.jumpToPage(_currentIndex);
          },
          cornerRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
          // shadowColor: const Color(0xff18786a),

          // elevation: 1,
          circleColor: const Color(0xff18786a),
          circleShadowColor: const Color(0xff18786a).withOpacity(.5),
        ),
      ),
    );
  }
}

class ActiveBttomNavWidget extends StatelessWidget {
  final String icon;

  const ActiveBttomNavWidget({
    super.key,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2.h,
      padding: const EdgeInsets.all(1),
      child: SvgPicture.asset(
        icon,
        fit: BoxFit.scaleDown,
        color: Colors.white,
      ),
    );
  }
}

class BottomNavCard extends StatelessWidget {
  final String icon;
  final String text;
  const BottomNavCard({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 2.75.h,
          padding: const EdgeInsets.all(1),
          child: SvgPicture.asset(
            icon,
            fit: BoxFit.scaleDown,
            color: Colors.black.withOpacity(.7),
          ),
        ),
        SizedBox(height: .5.h),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Colors.black.withOpacity(.7),
          ),
        ),
      ],
    );
  }
}
