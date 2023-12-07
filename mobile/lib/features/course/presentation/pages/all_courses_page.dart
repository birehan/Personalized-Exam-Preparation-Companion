import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/core.dart';
import '../../../features.dart';

class AlloursesPage extends StatefulWidget {
  const AlloursesPage({super.key});

  @override
  State<AlloursesPage> createState() => _AlloursesPageState();
}

class _AlloursesPageState extends State<AlloursesPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<UserCoursesBloc>().add(GetUsercoursesEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFCFCFf),
      // bottomNavigationBar: const MyBottomNavigation(
      //   index: 0,
      // ),
      extendBody: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'My Courses',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _searchController,
                    hintText: 'Find Course',
                    onTap: () {
                      context.read<SearchCourseBloc>().add(
                            const UserSearchCourseEvent(query: ''),
                          );
                      context.push(AppRoutes.searchPage);
                    },
                  ),
                ),
                SizedBox(
                  width: 5.w,
                ),
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Color(0xff18786A),
                  ),
                  child: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 3.h,
            ),
            const StartNewCourse(),
            SizedBox(
              height: 3.h,
            ),
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
                      return Center(
                        child: Text(state.errorMessage),
                      );
                    } else if (state is UserCoursesLoadedState) {
                      List<UserCourse> courses = state.courses;
                      if (courses.isEmpty) {
                        return const EmptyListWidget(
                          message: 'No courses available',
                        );
                        // return Center(
                        //     child: Column(
                        //   children: [
                        //     const Text(
                        //       'You have not started any courses yet.',
                        //       style: TextStyle(color: Color(0xff18786A)),
                        //     ),
                        //     const SizedBox(
                        //       height: 10,
                        //     ),
                        //     Image.asset('assets/images/no_data_image.png')
                        //   ],
                        // ));
                      }
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: courses.length,
                        itemBuilder: ((context, index) {
                          return EnrolledCoursesCard(
                            userCourse: courses[index],
                          );
                        }),
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
        height: 15.h,
        margin: EdgeInsets.symmetric(vertical: 1.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
