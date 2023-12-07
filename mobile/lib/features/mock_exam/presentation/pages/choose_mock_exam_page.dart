import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

import '../../../features.dart';

class ChooseMockExamPage extends StatefulWidget {
  final bool? forQuestionGeneration;
  const ChooseMockExamPage({super.key, this.forQuestionGeneration});

  @override
  State<ChooseMockExamPage> createState() => _ChooseMockExamPage();
}

class _ChooseMockExamPage extends State<ChooseMockExamPage> {
  @override
  void initState() {
    super.initState();
    // String departmentId = '64c24df185876fbb3f8dd6c7';
    String departmentId = '';

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
                'Choose your mock',
                style: GoogleFonts.poppins(
                  fontSize: 21,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Select mock you want to solve.',
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
                      ['Maths', state.departmentCourse!.maths],
                      ['Physics', state.departmentCourse!.physics],
                      ['SAT', state.departmentCourse!.sat],
                    ];

                    print(courseMap);

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: courseMap.length,
                      itemBuilder: (context, index) {
                        return MockExpandableWidget(
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
