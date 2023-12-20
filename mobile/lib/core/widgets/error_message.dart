import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  final String errorMessage;

  const CustomErrorWidget({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    // Show the SnackBar when the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          duration:
              const Duration(seconds: 5), // Duration to display the SnackBar
        ),
      );
    });

    // Return an empty container as the widget content
    return Container();
  }
}
