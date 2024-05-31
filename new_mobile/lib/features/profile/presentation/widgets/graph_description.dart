import 'package:flutter/material.dart';

class GraphDescription extends StatelessWidget {
  const GraphDescription({
    super.key,
    required this.title,
    required this.percent,
    required this.range,
    required this.numOfUsers,
  });
  final String title;
  final String percent;
  final String range;
  final String numOfUsers;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        // First Column with two Text widgets
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
            Text(
              percent,
              style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
        // Second Column with two Text widgets
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              range,
              style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
            Text(
              numOfUsers,
              style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }
}
