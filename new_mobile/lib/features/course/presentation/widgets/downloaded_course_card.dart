import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/routes/go_routes.dart';
import '../../../features.dart';

class DownloadedCourseCard extends StatelessWidget {
  const DownloadedCourseCard({
    super.key,
    required this.course,
  });

  final Course course;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        DownloadedCourseDetailPageRoute($extra: course).go(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              color: Colors.black.withOpacity(0.05),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 85,
              height: 85,
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                    fit: BoxFit.fitWidth,
                    image:
                        CachedNetworkImageProvider(course.image.imageAddress)),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${course.name} grade ${course.grade}',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(width: 1.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: .5.h),
                        decoration: BoxDecoration(
                          color: course.isNewCurriculum
                              ? const Color(0xff18786a).withOpacity(.1)
                              : const Color(0xffFEA800).withOpacity(.1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          course.isNewCurriculum
                              ? AppLocalizations.of(context)!.new_key
                              : AppLocalizations.of(context)!.old,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                            color: Color(course.isNewCurriculum
                                ? 0xff18786a
                                : 0xffFEA800),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.book_outlined,
                        color: Color(0xFF797979),
                        size: 18,
                      ),
                      Text(
                        '${course.chapters?.length ?? 0} ${AppLocalizations.of(context)!.chapters}',
                        style: GoogleFonts.poppins(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Expanded(
                  //       child: SizedBox(
                  //         height: 8,
                  //         child: ClipRRect(
                  //           borderRadius: BorderRadius.circular(8),
                  //           child: LinearProgressIndicator(
                  //             value: (course.completedChapters /
                  //                 course.course.numberOfChapters),
                  //             backgroundColor:
                  //                 const Color.fromRGBO(24, 120, 106, 0.1),
                  //             valueColor: const AlwaysStoppedAnimation<Color>(
                  //               Color(0xFF18786A),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     const SizedBox(width: 10),
                  //     Text(
                  //       '${((course.completedChapters / course.course.numberOfChapters) * 100).toInt().toStringAsFixed(0)} %',
                  //       style: GoogleFonts.poppins(
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.w500,
                  //         color: const Color(0xFF363636),
                  //       ),
                  //     )
                  //   ],
                  // ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
