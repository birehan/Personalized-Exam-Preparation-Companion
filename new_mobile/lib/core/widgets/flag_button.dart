import 'package:flutter/material.dart';
import 'package:prep_genie/features/feedback/presentation/widgets/flag_dialogue_box.dart';

class FlagButton extends StatelessWidget {
  const FlagButton({
    super.key,
    required this.onPressed,
  });
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(Icons.flag),
    );
  }
}
