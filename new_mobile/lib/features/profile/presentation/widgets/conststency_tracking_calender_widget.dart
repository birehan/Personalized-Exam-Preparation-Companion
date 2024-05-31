import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skill_bridge_mobile/features/profile/domain/entities/consistency_entity.dart';

class ConsistencyTrackingCalenderWidget extends StatelessWidget {
  final String month;
  final int numOfDays;
  final List<ConsistencyEntity> consistencyData;
  const ConsistencyTrackingCalenderWidget(
      {super.key,
      required this.month,
      required this.numOfDays,
      required this.consistencyData});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 25.w,
      child: Column(
        children: [
          SizedBox(
            height: 27.h,
            width: 25.w,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 1.0,
                crossAxisSpacing: 1.0,
              ),
              itemCount: numOfDays,
              itemBuilder: (context, index) {
                int dedication = consistencyData[index].overallPoint;
                Color cellColor = _getColorForDedication(dedication);
                final todaysConsistency = consistencyData[index];
                return Tooltip(
                  richMessage: TextSpan(children: [
                    const TextSpan(
                        text: 'Date: ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black)),
                    TextSpan(
                        text: DateFormat('MMM dd, yyyy')
                            .format(todaysConsistency.day),
                        style: const TextStyle(
                            fontFamily: 'Poppins', color: Colors.black)),
                    const TextSpan(
                        text: ' Mocks completed: ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black)),
                    TextSpan(
                        text: todaysConsistency.mockCompleted.toString(),
                        style: const TextStyle(
                            fontFamily: 'Poppins', color: Colors.black)),
                    const TextSpan(
                        text: ' Topics read: ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black)),
                    TextSpan(
                        text: todaysConsistency.subChapterCopleted.toString(),
                        style: const TextStyle(
                            fontFamily: 'Poppins', color: Colors.black)),
                    const TextSpan(
                        text: ' Quiz completed: ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black)),
                    TextSpan(
                        text: todaysConsistency.quizCompleted.toString(),
                        style: const TextStyle(
                            fontFamily: 'Poppins', color: Colors.black)),
                    const TextSpan(
                        text: ' Overall Points: ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black)),
                    TextSpan(
                        text: todaysConsistency.overallPoint.toString(),
                        style: const TextStyle(
                            fontFamily: 'Poppins', color: Colors.black)),
                    // TextSpan(
                    //   text:
                    //       'Mocks completed: ${todaysConsistency.mockCompleted}, Topics read: ${todaysConsistency.subChapterCopleted}, Quiz completed: ${todaysConsistency.quizCompleted}, Overall Point: ${todaysConsistency.overallPoint}',
                    //   style: const TextStyle(
                    //       fontFamily: 'Poppins', color: Colors.black),
                    // ),
                  ], style: const TextStyle()),

                  // textStyle: const TextStyle(
                  //     fontFamily: 'Poppins', color: Colors.black),
                  showDuration: const Duration(seconds: 30),
                  verticalOffset: 1.5.h,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff3F4B49).withOpacity(.07),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                    border: Border.all(
                      color: Colors.black12,
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 10.w),
                  triggerMode: TooltipTriggerMode.tap,
                  child: Container(
                    height: 16,
                    width: 16,
                    margin: const EdgeInsets.all(2.5),
                    decoration: BoxDecoration(
                      color: cellColor,
                      borderRadius: BorderRadius.circular(3.0),
                    ),
                  ),
                );
              },
            ),
          ),
          Text(
            month,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          )
        ],
      ),
    );
  }

  Color _getColorForDedication(int dedication) {
    if (dedication > 0 && dedication < 10) {
      return const Color(0xff18786a).withOpacity(.5);
    } else if (dedication >= 10 && dedication < 40) {
      return const Color(0xff18786a).withOpacity(.7);
    } else if (dedication >= 40) {
      return const Color(0xff18786a);
    } else {
      return Colors.black12;
    }
  }
}
