import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DailyQuestCard extends StatelessWidget {
  const DailyQuestCard({
    super.key,
    required this.iconBackground,
    required this.title,
    required this.taskDesciption,
    required this.totalTask,
    required this.completedTask,
  });
  final Color iconBackground;
  final String title;
  final String taskDesciption;
  final int totalTask;
  final int completedTask;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 4.w, right: 4.w, top: 1.5.h, bottom: 1.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              blurRadius: 20,
              spreadRadius: 5,
              color: Colors.black.withOpacity(.03),
              offset: const Offset(0, 0)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconBackground,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.checklist,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 3.w),
              SizedBox(
                width: 60.w,
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          // SizedBox(height: 2.h),
          SizedBox(height: 2.h),
          Row(
            children: [
              Container(
                height: 6,
                width: 6,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.black),
              ),
              SizedBox(width: 2.w),
              Text(
                '$completedTask of $totalTask $taskDesciption',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500, fontSize: 13),
              ),
              // SizedBox(height: 1.h),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          top: 1.5.h, bottom: 1.5.h, right: 1.w),
                      child: SizedBox(
                        height: 10,
                        // width: 70.w,
                        child: LinearProgressIndicator(
                          value: (completedTask / totalTask),
                          backgroundColor:
                              const Color.fromRGBO(24, 120, 106, 0.1),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF0072FF),
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        height: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                              color: completedTask == totalTask
                                  ? const Color(0xFF0072FF)
                                  : const Color.fromRGBO(24, 120, 106, 0.1),
                              shape: BoxShape.circle),
                          child: Icon(
                            Icons.card_giftcard_outlined,
                            color: completedTask == totalTask
                                ? Colors.white
                                : const Color(0xFF0072FF),
                            size: 18,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(width: 1.w),
              Text(
                '${totalTask * 10}xp',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
