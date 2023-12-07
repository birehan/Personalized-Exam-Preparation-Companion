import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skill_bridge_mobile/core/core.dart';
import 'package:skill_bridge_mobile/core/widgets/noInternet.dart';
import '../widgets/course_expandable_tile.dart';
import '../../../features.dart';

class ChooseSubjectPage extends StatefulWidget {
  final bool? forQuestionGeneration;
  const ChooseSubjectPage({super.key, this.forQuestionGeneration});

  @override
  State<ChooseSubjectPage> createState() => _ChooseSubjectPageState();
}

class _ChooseSubjectPageState extends State<ChooseSubjectPage> {
  String departmentId = '';
  @override
  void initState() {
    super.initState();
    // String departmentId = '64c24df185876fbb3f8dd6c7';

    final authenticationState = context.read<GetUserBloc>().state;

    if (authenticationState is GetUserCredentialState) {
      final userCredential = authenticationState.userCredential;
      if (userCredential!.departmentId != null &&
          userCredential.departmentId != '') {
        departmentId = userCredential.departmentId!;
      }
    }
    context
        .read<DepartmentCourseBloc>()
        .add(GetDepartmentCourseEvent(id: departmentId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose your subject',
                style: GoogleFonts.poppins(
                  fontSize: 21,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Select subject you want to study.',
                style: GoogleFonts.poppins(
                  color: const Color(0xFF939393),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 24),
              BlocBuilder<DepartmentCourseBloc, DepartmentCourseState>(
                builder: (context, state) {
                  if (state is GetDepartmentCourseState &&
                      state.status == DepartmentCourseStatus.loaded) {
                    final courseMap = [
                      ['Biology', state.departmentCourse!.biology],
                      ['Chemistry', state.departmentCourse!.chemistry],
                      ['Civics', state.departmentCourse!.civics],
                      ['English', state.departmentCourse!.english],
                      ['Mathematics', state.departmentCourse!.maths],
                      ['Physics', state.departmentCourse!.physics],
                      ['SAT', state.departmentCourse!.sat],
                      ['Others', state.departmentCourse!.others],
                      ['Economics', state.departmentCourse!.economics],
                      ['History', state.departmentCourse!.history],
                      ['Geography', state.departmentCourse!.geography],
                      ['Business', state.departmentCourse!.business],
                    ];

                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: courseMap.length,
                      itemBuilder: (context, index) {
                        if ((courseMap[index][1] as List<Course>).isEmpty) {
                          return Container();
                        }
                        return CourseExpandableWidget(
                          forQuestionGeneration: widget.forQuestionGeneration,
                          courseName: courseMap[index][0] as String,
                          courses: courseMap[index][1] as List<Course>,
                        );
                      },
                    );
                  } else if (state is GetDepartmentCourseState &&
                      state.status == DepartmentCourseStatus.loading) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: 6,
                        itemBuilder: (context, index) => _subListShimmer());
                  } else if (state is GetDepartmentCourseState &&
                      state.status == DepartmentCourseStatus.error &&
                      state.failure is NetworkFailure) {
                    return NoInternet(
                      reloadCallback: () {
                        context
                            .read<DepartmentCourseBloc>()
                            .add(GetDepartmentCourseEvent(id: departmentId));
                      },
                    );
                  }

                  return Container();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Shimmer _subListShimmer() {
    return Shimmer.fromColors(
        direction: ShimmerDirection.ltr,
        baseColor: const Color.fromARGB(255, 236, 235, 235),
        highlightColor: const Color(0xffF9F8F8),
        child: Padding(
          padding: EdgeInsets.only(top: 2.h),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 2.h,
                    width: 3.w,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  SizedBox(
                    width: 2.w,
                  ),
                  Container(
                    height: 3.h,
                    width: 75.w,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                  )
                ],
              ),
              SizedBox(
                height: 2.h,
              ),
              const Divider(
                color: Colors.white,
                height: 2,
                indent: 10,
              )
            ],
          ),
        ));
  }
}