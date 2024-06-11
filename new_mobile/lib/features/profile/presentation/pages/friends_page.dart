import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:prep_genie/core/core.dart';
import 'package:prep_genie/features/profile/presentation/widgets/friends_tab.dart';
import 'package:prep_genie/features/profile/presentation/widgets/requests_tab.dart';

class FriendsMainPage extends StatefulWidget {
  const FriendsMainPage({super.key});

  @override
  State<FriendsMainPage> createState() => _FriendsMainPageState();
}

class _FriendsMainPageState extends State<FriendsMainPage>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  int _tabIndex = 0;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _tabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(() {});
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 8.h,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.keyboard_backspace),
        ),
        title: const Text(
          'Friends',
          style: TextStyle(
              fontFamily: 'Poppins', fontSize: 20, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              AddFriendspageRoute().go(context);
            },
            icon: const Icon(Icons.person_add_alt_1_sharp),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 7.w),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xffF2F4F6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TabBar(
                controller: _tabController,
                labelPadding: EdgeInsets.zero,
                dividerColor: Colors.transparent,
                indicatorColor: const Color(0xffF2F4F6),
                indicatorPadding: EdgeInsets.symmetric(horizontal: 20.w),
                indicatorWeight: .001,
                tabs: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: _tabIndex == 0
                          ? const Color(0xff1A7A6C)
                          : Colors.transparent,
                    ),
                    child: Text(
                      'Friends',
                      style: TextStyle(
                          color: _tabIndex == 0 ? Colors.white : Colors.black,
                          fontFamily: 'Poppins'),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: _tabIndex == 1
                          ? const Color(0xff1A7A6C)
                          : Colors.transparent,
                    ),
                    child: Text(
                      'Requests',
                      style: TextStyle(
                        color: _tabIndex == 1 ? Colors.white : Colors.black,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 1.h),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  FriendsTab(),
                  RequestsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
