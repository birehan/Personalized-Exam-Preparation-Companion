import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:prep_genie/core/widgets/noInternet.dart';
import '../../../../core/core.dart';
import '../../../features.dart';

class DownloadedCourseDetailPage extends StatelessWidget {
  const DownloadedCourseDetailPage({
    super.key,
    required this.course,
  });

  final Course course;

  @override
  Widget build(BuildContext context) {
    double appBarHeight = 33.h;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            context.pop();
          },
        ),
        centerTitle: true,
        title: Text(
          '${course.name} grade ${course.grade}',
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: DownloadedCourseDetailTab(
        course: course,
      ),
    );
  }
}
