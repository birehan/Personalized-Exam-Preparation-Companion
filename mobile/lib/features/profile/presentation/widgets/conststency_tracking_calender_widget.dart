import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
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

                return Container(
                  height: 16,
                  width: 16,
                  margin: const EdgeInsets.all(2.5),
                  decoration: BoxDecoration(
                    color: cellColor,
                    borderRadius: BorderRadius.circular(3.0),
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
