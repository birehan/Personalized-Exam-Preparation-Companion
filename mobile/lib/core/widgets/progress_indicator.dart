import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class CustomProgressIndicator extends StatelessWidget {
  final double? size;
  final Color? color;
  const CustomProgressIndicator({
    super.key,
    this.size = 40,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size,
        width: size,
        child: LoadingIndicator(
          indicatorType: Indicator.values[24],
          colors: [color ?? const Color(0xff18786A)],
          strokeWidth: 4.0,
          pathBackgroundColor: Colors.black45,
        ),
      ),
    );
  }
}
