import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../features.dart';
import '../bloc/course/course_bloc.dart';
import '../bloc/registerCourse/register_course_bloc.dart';

class SelectCoursePage extends StatefulWidget {
  const SelectCoursePage({super.key});

  @override
  State<SelectCoursePage> createState() => _SelectCoursePageState();
}

class _SelectCoursePageState extends State<SelectCoursePage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 3.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Course',
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 3.h),
            SizedBox(height: 2.h),
            const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Filtered By:'),
                Text(
                  ' Year',
                  style: TextStyle(
                    color: Color(0xff18786A),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 3.h,
            ),
            Expanded(
              child: BlocBuilder<SelectCourseBloc, SelectCourseState>(
                builder: (context, state) {
                  if (state is DepartmentCoursesFailedState) {
                    return Center(
                      child: Text(state.message),
                    );
                  } else if (state is DepartmentCoursesLoadingState) {
                    return GridView.builder(
                      shrinkWrap: true,
                      itemCount: 12,
                      physics: const ClampingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // Number of columns
                        mainAxisSpacing: 10.0, // Spacing between rows
                        crossAxisSpacing: 5.0, // Spacing between columns
                        childAspectRatio:
                            0.72, // Width to height ratio of each grid item
                      ),
                      itemBuilder: (context, index) {
                        return _courseLoadingShimmer();
                      },
                    );
                  } else if (state is DepartmentCoursesLoadedState) {
                    List<Course> courses = state.courses;
                    if (courses.isEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'No courses availabe',
                            style: TextStyle(
                              color: Color(0xff18786A),
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Image.asset('assets/images/no_data_image.png'),
                        ],
                      );
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      itemCount: courses.length,
                      physics: const ClampingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // Number of columns
                        mainAxisSpacing: 10.0, // Spacing between rows
                        crossAxisSpacing: 5.0, // Spacing between columns
                        childAspectRatio:
                            0.65, // Width to height ratio of each grid item
                      ),
                      itemBuilder: (context, index) {
                        ImageProvider? imageProvider;
                        courses[index].image != null &&
                                courses[index].image!.imageAddress != null
                            ? imageProvider = NetworkImage(
                                courses[index].image!.imageAddress!)
                            : imageProvider =
                                const AssetImage(courseDefaultImageAddress);
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                context.read<CourseBloc>().add(
                                      SetCourseEvent(course: courses[index]),
                                    );
                                context.read<RegisterCourseBloc>().add(
                                    RegisterUserToACourse(
                                        courseId: courses[index].id));
                                context.push(AppRoutes.courseOption,
                                    extra: courses[index]);
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image(
                                    fit: BoxFit.cover,
                                    height: 14.h,
                                    width: 27.w,
                                    image: imageProvider),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                courses[index].name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            )
                          ],
                        );
                      },
                    );
                  }
                  return Container();
                },
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
      baseColor: const Color.fromARGB(255, 240, 238, 238),
      highlightColor: const Color(0xffF1EFEF),
      child: SizedBox(
        child: Column(
          children: [
            Container(
              height: 14.h,
              width: 27.w,
              decoration: BoxDecoration(
                color: const Color(0xffF1EFEF),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            SizedBox(
              height: 1.h,
            ),
            Container(
              height: 4.h,
              width: 27.w,
              decoration: BoxDecoration(
                color: const Color(0xffF9F8F8),
                borderRadius: BorderRadius.circular(12),
              ),
            )
          ],
        ),
      ),
    );
  }
}
