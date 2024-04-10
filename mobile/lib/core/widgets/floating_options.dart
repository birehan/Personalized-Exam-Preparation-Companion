import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class FloatingOptions extends StatelessWidget {
  final Function() flagCallback;
  final Function() chatCallback;
  final bool hideChat;
  final Color? color;

  const FloatingOptions({
    super.key,
    required this.flagCallback,
    required this.chatCallback,
    required this.hideChat,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      icon: Icons.dashboard,
      activeIcon: Icons.close,
      spacing: 6,
      childPadding: const EdgeInsets.all(2),
      iconTheme: const IconThemeData(color: Colors.white),
      spaceBetweenChildren: 5,
      backgroundColor: color ?? const Color(0xff1A7A6C),
      elevation: 1,
      children: [
        if (!hideChat)
          SpeedDialChild(
            shape: const CircleBorder(),
            child: const Icon(Icons.wechat),
            backgroundColor: Colors.white,
            // label: 'chat',
            onTap: chatCallback,
            elevation: 2,
          ),
        SpeedDialChild(
          shape: const CircleBorder(),
          child: const Icon(Icons.assistant_photo),
          backgroundColor: Colors.white,
          onTap: flagCallback,
          // label: 'flag content',
          elevation: 2,
        ),
      ],
    );
  }
}

class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  final double x;
  final double y;

  const CustomFloatingActionButtonLocation(this.x, this.y);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final double fabX = scaffoldGeometry.scaffoldSize.width * x;
    final double fabY = scaffoldGeometry.scaffoldSize.height * y;
    return Offset(fabX, fabY);
  }
}
