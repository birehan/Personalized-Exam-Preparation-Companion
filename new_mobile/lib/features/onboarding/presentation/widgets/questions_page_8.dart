import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:prep_genie/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:prep_genie/features/profile/presentation/bloc/schoolInfoBloc/school_bloc.dart';
import 'package:prep_genie/features/profile/presentation/widgets/dropdown_with_userinput.dart';
import 'package:prep_genie/features/profile/presentation/widgets/profile_dropdown_selection.dart';

class OnboardingSchoolsPage extends StatelessWidget {
  const OnboardingSchoolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 2.h),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Column(
                children: [
                  const Text(
                    'Select the school you go to.',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/onboarding/schoolInfo.png',
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      )
                    ],
                  ),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
            SizedBox(
              height: 3.h,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<SchoolBloc, SchoolState>(
                  builder: (context, state) {
                    if (state is SchoolLoadedState) {
                      final schoolInfo = state.schoolDepartmentInfo.schoolInfo;
                      final regionInfo = state.schoolDepartmentInfo.regionInfo;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropDownWithUserInput(
                            lable: '',
                            selectedCallback: (val) {
                              if (val != null) {
                                context
                                    .read<OnboardingBloc>()
                                    .add(SchoolChangedEvent(school: val));
                                return;
                              }
                            },
                            title: 'High School',
                            items: schoolInfo.map((e) => e.schoolName).toList(),
                            hintText: 'Select your schoool',
                          ),
                          SizedBox(height: 3.h),
                          ProfileDropdownOptions(
                            lable: '',
                            selectedCallback: (val) {
                              if (val != null) {
                                context
                                    .read<OnboardingBloc>()
                                    .add(RegionChnagedEvent(region: val));
                              }
                            },
                            title: 'Region',
                            items: regionInfo,
                            hintText: 'Select your region',
                            width: 92.w,
                          ),
                          SizedBox(height: 3.h),
                          ProfileDropdownOptions(
                            width: 92.w,
                            selectedCallback: (val) {
                              if (val != null) {
                                context
                                    .read<OnboardingBloc>()
                                    .add(GenderChangedEvent(gender: val));
                              }
                            },
                            hintText: 'Select your gender',
                            title: 'Gender',
                            lable: '',
                            items: const ['Male', 'Female'],
                          )
                        ],
                      );
                    }
                    return Container();
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
