import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../routes/app_routes.dart';

class MyBottomNavigation extends StatefulWidget {
  final int index;
  const MyBottomNavigation({
    super.key,
    required this.index,
  });

  @override
  State<MyBottomNavigation> createState() => _MyBottomNavigationState();
}

class _MyBottomNavigationState extends State<MyBottomNavigation> {
  late int currentIndex;
  @override
  void initState() {
    super.initState();
    currentIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedLabelStyle: GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      selectedItemColor: const Color(0xFF18786A),
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
        if (index == 0) {
          context.push(AppRoutes.allCoursesPage);
        } else if (index == 1) {
          context.push(AppRoutes.home);
        } else if (index == 2) {
          context.push(AppRoutes.settingsPage);
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage('assets/images/home_off.png')),
          activeIcon: ImageIcon(AssetImage('assets/images/home_on.png')),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage('assets/images/course_off.png')),
          activeIcon: ImageIcon(AssetImage('assets/images/course_on.png')),
          label: 'Courses',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage('assets/images/course_off.png')),
          activeIcon: ImageIcon(AssetImage('assets/images/course_on.png')),
          label: 'Courses',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage('assets/images/profile_off.png')),
          activeIcon: ImageIcon(AssetImage('assets/images/profile_on.png')),
          label: 'Profile',
        ),
      ],
    );
  }
}
