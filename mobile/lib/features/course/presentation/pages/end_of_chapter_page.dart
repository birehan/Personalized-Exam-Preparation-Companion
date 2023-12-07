import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skill_bridge_mobile/core/core.dart';

class EndOfChapterPage extends StatelessWidget {
  final String courseId;
  const EndOfChapterPage({
    super.key,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 8.h,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.only(top: 1.h),
          child: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(),
            Image.asset(
              'assets/images/end_of_chapter_image.png',
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF18786A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      context.pop();
                    },
                    child: Text(
                      'Start Question',
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    // return Scaffold(
    //   backgroundColor: Colors.white,
    //   body: Center(
    //     child: ClipRect(
    //       child: Stack(
    //         children: [
    //           Stack(
    //             children: [
    //               SizedBox(
    //                 height: 35.h,
    //               ),
    //               Image(
    //                 height: 25.h,
    //                 image: const AssetImage(
    //                   'assets/images/contnent_compilation.jpg',
    //                 ),
    //               ),
    //               Positioned(
    //                 top: 10.h,
    //                 left: 15.w,
    //                 child: SizedBox(
    //                   height: 20.h,
    //                   width: 40.w,
    //                   child: const Text(
    //                       "Congratulationsyou have completed the chapter. Let's do some questions."),
    //                 ),
    //               ),
    //               Positioned(
    //                 bottom: -2.h,
    //                 left: -12.w,
    //                 child: Image(
    //                   height: 20.h,
    //                   image: const AssetImage('assets/images/robot.png'),
    //                 ),
    //               )
    //             ],
    //           ),
    //           Container(
    //             color: Colors.red,
    //             height: 2.h,
    //           )
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
