import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skill_bridge_mobile/features/profile/presentation/bloc/barChartBloc/bar_chart_bloc.dart';
import 'package:skill_bridge_mobile/features/profile/presentation/widgets/barchart.dart';
import 'dart:math' as math;

import 'package:skill_bridge_mobile/features/profile/presentation/widgets/graph_description.dart';

class BarChartWithDesctiption extends StatelessWidget {
  const BarChartWithDesctiption({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 30.h,
        child: BlocBuilder<BarChartBloc, BarChartState>(
          builder: (context, state) {
            if (state is BarChartDataLoadFailedState) {
              return const Center(
                child: Text('Failed to load bar chart data'),
              );
            } else if (state is BarChartDataLoadingState) {
              return _barChartWidgetShimmer();
            } else if (state is BarChartDataLoadedState) {
              int total = 0;
              int max = 0;

              for (int i = 0; i < state.categories.categories.length; i++) {
                total += state.categories.categories[i].count;
                max = math.max(max, state.categories.categories[i].count);
              }

              return Column(
                children: [
                  GraphDescription(
                    numOfUsers: '$total Users',
                    percent:
                        '${state.categories.userCategory.percentile.toStringAsFixed(2)} %',
                    range:
                        '${state.categories.userCategory.end.ceil()} - ${state.categories.userCategory.start.ceil()}',
                    title: 'Top',
                  ),
                  SizedBox(height: 3.h),
                  BarChartWidget(
                    scoreCategoryListEntity: state.categories,
                    maxItemCount: max,
                  ),
                ],
              );
            }
            return Container();
          },
        ));
  }
}

Shimmer _barChartWidgetShimmer() {
  return Shimmer.fromColors(
    direction: ShimmerDirection.ltr,
    baseColor: const Color.fromARGB(255, 236, 235, 235),
    highlightColor: const Color(0xffF9F8F8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 3.h,
                  width: 20.w,
                  margin: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                SizedBox(height: .5.h),
                Container(
                  height: 3.h,
                  width: 25.w,
                  margin: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 3.h,
                  width: 20.w,
                  margin: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                SizedBox(height: .5.h),
                Container(
                  height: 3.h,
                  width: 25.w,
                  margin: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                )
              ],
            )
          ],
        ),
        SizedBox(height: 1.h),
        SizedBox(
          height: 17.h,
          width: 85.w,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => Container(
              height: 10.h, // Set the desired height here
              width: 8.w,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
            ),
            separatorBuilder: (context, index) => SizedBox(
              width: 3.w,
            ),
            itemCount: 8,
          ),
        )
      ],
    ),
  );
}
