import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class CustomLinearProgressIndicator extends StatelessWidget {
  final double? size;
  final Color color;
  const CustomLinearProgressIndicator({
    super.key,
    this.size = 40,
    this.color = const Color(0xff18786a),
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size,
        width: size,
        child: LoadingIndicator(
          indicatorType: Indicator.values[18],
          colors: [color],
          strokeWidth: 4.0,
          pathBackgroundColor: Colors.black45,
        ),
      ),
    );
  }
}
