import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:prepgenie/core/bloc/tokenSession/token_session_bloc.dart';
import 'package:prepgenie/core/widgets/noInternet.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/core.dart';
import '../../../features.dart';
import '../widgets/mycourses_card.dart';

class MyCoursesPage extends StatefulWidget {
  const MyCoursesPage({super.key});

  @override
  State<MyCoursesPage> createState() => _MyCoursesPageState();
}

class _MyCoursesPageState extends State<MyCoursesPage>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController searchController = TextEditingController();
  int _tabIndex = 0;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _tabIndex = _tabController.index;
      });
    });
    super.initState();
    context
        .read<UserCoursesBloc>()
        .add(const GetUsercoursesEvent(refresh: false));
  }

  @override
  void dispose() {
    searchController.dispose();
    _tabController.removeListener(() {});
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<TokenSessionBloc, TokenSessionState>(
        listener: (context, state) {
          if (state is TokenSessionExpiredState) {
            LoginPageRoute().go(context);
          }
        },
        child: Padding(
          padding: EdgeInsets.only(top: 3.h, right: 5.w, left: 5.w),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 2.w),
                  Text(
                    AppLocalizations.of(context)!.my_courses,
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      SearchCoursesPageRoute().go(context);
                    },
                    child: Container(
                      height: 2.75.h,
                      padding: const EdgeInsets.all(1),
                      child: SvgPicture.asset(
                        searchIcon,
                        // height: .3.h,
                        fit: BoxFit.scaleDown,
                        // width: 1.w,
                        color: Colors.black.withOpacity(.7),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3.h),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xffF2F4F6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TabBar(
                  controller: _tabController,
                  labelPadding: EdgeInsets.zero,
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
                            ? const Color(0xff18786a)
                            : Colors.transparent,
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.lesson,
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
                            ? const Color(0xff18786a)
                            : Colors.transparent,
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.bookmarks,
                        style: TextStyle(
                          color: _tabIndex == 1 ? Colors.white : Colors.black,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 3.h),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Stack(
                      children: [
                        RefreshIndicator(
                          onRefresh: () async {
                            context.read<UserCoursesBloc>().add(
                                  const GetUsercoursesEvent(refresh: true),
                                );
                          },
                          child: BlocBuilder<UserCoursesBloc, UserCoursesState>(
                            builder: (context, state) {
                              if (state is UserCoursesLoadingState) {
                                return Center(
                                  child: ListView.builder(
                                    itemCount: 4,
                                    itemBuilder: (context, index) {
                                      return _courseLoadingShimmer();
                                    },
                                  ),
                                );
                              } else if (state is UserCoursesFailedState) {
                                if (state.failure is NetworkFailure) {
                                  return NoInternet(
                                    reloadCallback: () {
                                      context.read<UserCoursesBloc>().add(
                                          const GetUsercoursesEvent(
                                              refresh: true));
                                    },
                                  );
                                } else if (state.failure
                                    is AuthenticationFailure) {
                                  return const Center(
                                    child: SessionExpireAlert(),
                                  );
                                }
                                return Center(
                                  child: Text(state.errorMessage),
                                );
                              } else if (state is UserCoursesLoadedState) {
                                List<UserCourse> courses = state.courses;
                                if (courses.isEmpty) {
                                  return EmptyListWidget(
                                    message: AppLocalizations.of(context)!
                                        .no_bookmark,
                                  );
                                }
                                return ListView.separated(
                                  separatorBuilder: (context, index) =>
                                      SizedBox(height: 2.h),
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  itemCount: courses.length,
                                  itemBuilder: (context, index) =>
                                      MyCoursesCard(
                                    userCourse: courses[index],
                                  ),
                                );
                              }
                              return Container();
                            },
                          ),
                        ),
                        Positioned(
                          bottom: 2.h,
                          right: 4.w,
                          child: const FloatingWidget(),
                        )
                      ],
                    ),
                    const BookmarksPage()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Shimmer _courseLoadingShimmer() {
    return Shimmer.fromColors(
      direction: ShimmerDirection.ttb,
      baseColor: const Color.fromARGB(255, 236, 235, 235),
      highlightColor: const Color(0xffF9F8F8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Container(
              width: 85,
              height: 85,
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 2.h,
                    width: 50.w,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(3)),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        height: 2.h,
                        width: 2.h,
                        decoration: const BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                      ),
                      SizedBox(width: 2.w),
                      Container(
                        height: 2.h,
                        width: 25.w,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(3)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          height: 2.h,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(3)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        height: 2.h,
                        width: 4.w,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(3)),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FloatingWidget extends StatelessWidget {
  const FloatingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        ChooseSubjectPageRoute().go(context);
      },
      child: Container(
        width: 32.w,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 1.5.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: const Color(0xff18786a),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add,
              color: Colors.white,
              size: 20,
            ),
            Text(
              AppLocalizations.of(context)!.new_course,
              style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}
