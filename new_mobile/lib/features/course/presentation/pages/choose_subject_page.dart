import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skill_bridge_mobile/core/core.dart';
import 'package:skill_bridge_mobile/core/widgets/noInternet.dart';
import '../../../../core/utils/snack_bar.dart';
import '../widgets/course_expandable_tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../features.dart';

class ChooseSubjectPage extends StatefulWidget {
  final bool? forQuestionGeneration;
  const ChooseSubjectPage({super.key, this.forQuestionGeneration});

  @override
  State<ChooseSubjectPage> createState() => _ChooseSubjectPageState();
}

class _ChooseSubjectPageState extends State<ChooseSubjectPage> {
  String departmentId = '';
  Map<String, String> courseImageUrls = {
    'Biology': 'assets/images/Biology.png',
    'Chemistry': 'assets/images/Chemistry.png',
    'Civics': 'assets/images/Civics.png',
    'English': 'assets/images/English.png',
    'Mathematics': 'assets/images/maths.png',
    'Physics': 'assets/images/Physics.png',
    'SAT': 'assets/images/SAT.png',
    'Economics': 'assets/images/Economics_subject.png',
    'History': 'assets/images/History.png',
    'Geography': 'assets/images/Geography.png',
    'Business':
        'assets/images/Geography.png', //! should be replaced with the correct image
    'Others':
        'assets/images/Geography.png', //! should be replaced with the correct image
  };

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
                AppLocalizations.of(context)!.choose_your_subject,
                style: GoogleFonts.poppins(
                  fontSize: 21,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                AppLocalizations.of(context)!.select_subject_you_want_to_study, 
                style: GoogleFonts.poppins(
                  color: const Color(0xFF939393),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 24),
              BlocListener<DepartmentCourseBloc, DepartmentCourseState>(
                listener: (context, state) {
                  if (state is GetDepartmentCourseState &&
                      state.status == DepartmentCourseStatus.error &&
                      state.failure is RequestOverloadFailure) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(snackBar(state.failure!.errorMessage));
                  }
                },
                child: BlocBuilder<DepartmentCourseBloc, DepartmentCourseState>(
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
                        ['Economics', state.departmentCourse!.economics],
                        ['History', state.departmentCourse!.history],
                        ['Geography', state.departmentCourse!.geography],
                        ['Business', state.departmentCourse!.business],
                        ['Others', state.departmentCourse!.others],
                      ];

                      return ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: courseMap.length,
                        separatorBuilder: (context, state) =>
                            const SizedBox(height: 6),
                        itemBuilder: (context, index) {
                          if ((courseMap[index][1] as List<Course>).isEmpty) {
                            return Container();
                          }
                          return CourseExpandableWidget(
                            courseUrl:
                                courseImageUrls[courseMap[index][0] as String]
                                    as String,
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
                    } else if (state is GetDepartmentCourseState) {
                      if (state.status == DepartmentCourseStatus.error &&
                          state.failure is NetworkFailure) {
                        return NoInternet(
                          reloadCallback: () {
                            context.read<DepartmentCourseBloc>().add(
                                GetDepartmentCourseEvent(id: departmentId));
                          },
                        );
                      }
                    }
                    return Container();
                  },
                ),
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
