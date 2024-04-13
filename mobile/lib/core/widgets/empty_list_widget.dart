import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../features/features.dart';

class EmptyListWidget extends StatelessWidget {
  const EmptyListWidget({
    super.key,
    this.title,
    required this.message,
    this.width,
    this.height,
    this.reloadCallBack,
    this.showImage = true,
  });

  final String? title;
  final String message;
  final double? width;
  final double? height;
  final Function? reloadCallBack;
  final bool showImage;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (showImage)
          Image.asset(
            'assets/images/no_data_image.png',
            width: width,
            height: height,
          ),
        const SizedBox(height: 8),
        reloadCallBack == null
            ? Text(
                title ?? 'Empty',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              )
            : IconButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xFF0072FF)),
                ),
                icon: const Icon(
                  Icons.refresh,
                  color: Colors.white,
                  // size: 18,
                ),
                onPressed: () {
                  reloadCallBack!();
                },
              ),

        // InkWell(
        //     onTap: () {
        //       reloadCallBack!();
        //     },
        //     child: Container(
        //       padding:
        //           const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
        //       decoration: BoxDecoration(
        //         color: const Color(0xFF0072FF),
        //         borderRadius: BorderRadius.circular(4),
        //       ),
        //       child: Row(
        //         mainAxisSize: MainAxisSize.min,
        //         children: [
        //           const Icon(Icons.refresh, color: Colors.white, size: 18),
        //           // const SizedBox(width: 6),
        //           // Text(
        //           //   'Refresh',
        //           //   style: GoogleFonts.poppins(
        //           //     color: Colors.white,
        //           //   ),
        //           // ),
        //         ],
        //       ),
        //     ),
        //   ),
        const SizedBox(height: 8),
        Text(
          message,
          style: GoogleFonts.poppins(
            color: const Color(0xFF797979),
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
