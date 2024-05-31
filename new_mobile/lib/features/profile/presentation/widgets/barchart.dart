import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skill_bridge_mobile/features/profile/domain/entities/all_barchart_categories_entity.dart';

class BarChartWidget extends StatefulWidget {
  BarChartWidget(
      {super.key,
      required this.scoreCategoryListEntity,
      required this.maxItemCount});

  final Color barBackgroundColor = Colors.black.withOpacity(0.3);
  final Color barColor = const Color(0xff18786a);
  final ScoreCategoryListEntity scoreCategoryListEntity;
  final int maxItemCount;

  @override
  State<StatefulWidget> createState() => BarChartSample1State();
}

class BarChartSample1State extends State<BarChartWidget> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2.3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: BarChart(
              randomData(),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y,
  ) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color:
              x != (widget.scoreCategoryListEntity.userCategory.range / 10) - 1
                  ? const Color(0xffD9D9D9)
                  : widget.barColor,
          borderRadius: BorderRadius.zero,
          borderDashArray: x >= 4 ? [4, 4] : null,
          width: 24,
        ),
      ],
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff18786a),
      fontWeight: FontWeight.w300,
      fontFamily: 'Poppins',
      fontSize: 12,
    );
    List<String> range = [
      '10%',
      '20%',
      '30%',
      '40%',
      '50%',
      '60%',
      '70%',
      '80%',
      '90%',
      '100%',
    ];

    Widget text = Text(
      range[value.toInt()],
      style: style,
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }

  BarChartData randomData() {
    return BarChartData(
      maxY: widget.maxItemCount.toDouble(),
      barTouchData: BarTouchData(
        enabled: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(
            reservedSize: 30,
            showTitles: false,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: List.generate(
        widget.scoreCategoryListEntity.categories.length,
        (i) => makeGroupData(
          widget.scoreCategoryListEntity.categories.length - i - 1,
          widget
                  .scoreCategoryListEntity
                  .categories[
                      widget.scoreCategoryListEntity.categories.length - i - 1]
                  .count
                  .toDouble() +
              1,
        ),
      ),
      gridData: const FlGridData(show: false),
    );
  }
}
