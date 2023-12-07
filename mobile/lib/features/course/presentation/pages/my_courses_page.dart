import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skill_bridge_mobile/core/widgets/noInternet.dart';

import '../../../../core/core.dart';
import '../../../features.dart';
import '../widgets/mycourses_card.dart';

class MyCoursesPage extends StatefulWidget {
  const MyCoursesPage({super.key});

  @override
  State<MyCoursesPage> createState() => _MyCoursesPageState();
}

class _MyCoursesPageState extends State<MyCoursesPage> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<UserCoursesBloc>().add(GetUsercoursesEvent());
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'My Courses',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                SearchCoursesPageRoute().go(context);
              },
              child: MySearchWidget(
                enabled: false,
                searchController: searchController,
                iconData: Icons.search,
                hintText: 'Find Course',
              ),
            ),
            const SizedBox(height: 24),
            const StartNewCourse(),
            const SizedBox(height: 24),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<UserCoursesBloc>().add(
                        GetUsercoursesEvent(),
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
                            context
                                .read<UserCoursesBloc>()
                                .add(GetUsercoursesEvent());
                          },
                        );
                      }
                      return Center(
                        child: Text(state.errorMessage),
                      );
                    } else if (state is UserCoursesLoadedState) {
                      List<UserCourse> courses = state.courses;
                      if (courses.isEmpty) {
                        return const EmptyListWidget(
                          message: 'No courses available',
                        );
                      }

                      return ListView.separated(
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 2.h),
                        physics: const BouncingScrollPhysics(),
                        itemCount: courses.length,
                        itemBuilder: (context, index) => MyCoursesCard(
                          userCourse: courses[index],
                        ),
                      );
                    }
                    return Container();
                  },
                ),
              ),
            )
          ],
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
