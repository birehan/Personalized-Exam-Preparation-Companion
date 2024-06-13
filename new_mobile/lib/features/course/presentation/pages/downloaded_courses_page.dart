import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../features.dart' hide CourseCard;
import '../../domain/entities/course_image.dart';
import '../widgets/downloaded_course_card.dart';

class DownloadedCoursesPage extends StatefulWidget {
  const DownloadedCoursesPage({
    super.key,
  });

  @override
  State<DownloadedCoursesPage> createState() => _DownloadedCoursesPageState();
}

class _DownloadedCoursesPageState extends State<DownloadedCoursesPage> {
  @override
  void initState() {
    super.initState();
    context.read<OfflineCourseBloc>().add(
          FetchDownloadedCourseEvent(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OfflineCourseBloc, OfflineCourseState>(
      builder: (context, state) {
        if (state is FetchDownloadedCoursesLoading) {
          return const Center(child: Text('loading....'));
        } else if (state is FetchDownloadedCoursesLoaded) {
          if (state.courses.isEmpty) {
            return Center(
              child: Text(
                'No downloaded courses found',
                style: GoogleFonts.poppins(),
              ),
            );
          }
          return ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: 2.h),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: state.courses.length,
            itemBuilder: (context, index) => DownloadedCourseCard(
              course: state.courses[index],
            ),
          );
        } else if (state is FetchDownloadedCoursesFailed) {
          return const Center(child: Text('failed....'));
        }
        return Container();
      },
    );
  }
}
