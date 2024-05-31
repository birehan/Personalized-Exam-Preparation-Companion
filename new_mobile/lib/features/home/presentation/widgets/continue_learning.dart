import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../features.dart';

class ContinueLearningWidget extends StatelessWidget {
  const ContinueLearningWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.continue_learning,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF363636),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppLocalizations.of(context)!.browse_from_existing_categories,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF939393),
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () {},
              child: Text(
                AppLocalizations.of(context)!.see_all,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: const Color(0XFF18786A),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 145,
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is GetMyCoursesState &&
                  state.status == HomeStatus.loaded) {
                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) =>
                      CourseCard(userCourse: state.userCourses![index]),
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 12),
                  itemCount: state.userCourses!.length,
                );
              } else if (state is GetMyCoursesState &&
                  state.status == HomeStatus.error) {
                return Container();
              }
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => const ShimmerCourseCard(),
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemCount: 4,
              );
            },
          ),
        ),

        // SizedBox(
        //   height: 200,
        //   child: ListView.separated(
        //     scrollDirection: Axis.horizontal,
        //     itemBuilder: (context, index) => const CourseCard(),
        //     separatorBuilder: (context, index) => const SizedBox(width: 12),
        //     itemCount: 4,
        //   ),
        // )
      ],
    );
  }
}
