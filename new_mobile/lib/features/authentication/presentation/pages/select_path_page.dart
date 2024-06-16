import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../department/department.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../widgets/preparation_card.dart';

class SelectPathPage extends StatelessWidget {
  const SelectPathPage({super.key});

  @override
  Widget build(BuildContext context) {
    const pathImages = {
      'University Entrance Exam': 'assets/images/u_enterance.png',
      'University Exit Exam': 'assets/images/u_exit.png',
    };

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              AppLocalizations.of(context)!.what_exam_are_you_preparing_for,
              style: const TextStyle(
                fontSize: 28,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2.h),
             Text(
             AppLocalizations.of(context)!.let_us_setup_the_learning_enviroment_based_on_you_exam_type,
              style: const TextStyle(
                  //chagne
                  color: Color(0xffA3A2B1),
                  fontSize: 18,
                  fontFamily: 'Poppins'),
            ),
            SizedBox(height: 5.h),
            BlocBuilder<DepartmentBloc, DepartmentState>(
              builder: (context, state) {
                if (state is GetDepartmentState &&
                    state.status == GetDepartmentStatus.loaded) {
                  final generalDepartmentWidgets = state.generalDepartments!
                      .where(
                        (generalDepartment) => generalDepartment.isForListing,
                      )
                      .map(
                        (generalDepartment) => Expanded(
                          child: InkWell(
                            onTap: () {},
                            child: PreparationCard(
                              text: generalDepartment.name,
                              image:
                                  pathImages[generalDepartment.name] as String,
                            ),
                          ),
                        ),
                      )
                      .toList();

                  return Row(
                    children: generalDepartmentWidgets,
                  );
                }
                return Container();
              },
            )
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Expanded(
            //       child: InkWell(
            //         onTap: () {
            //           //! direct to exit exam change
            //           // What the heck
            //         },
            //         child: const PreparationCard(
            //           image: 'assets/images/u_exit.png',
            //           text: 'University Exit Exam',
            //         ),
            //       ),
            //     ),
            //     SizedBox(width: 5.w),
            //     Expanded(
            //       child: InkWell(
            //         onTap: () {
            //           //! direct to enterance impl
            //         },
            //         child: const PreparationCard(
            //           image: 'assets/images/u_enterance.png',
            //           text: 'University Enterance Exam',
            //         ),
            //       ),
            //     ),
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
