import 'dart:async';

import 'package:flutter/material.dart';

/// DoubleBack, wrap a widget to use it
/// child : widget
/// message : to show on toast
/// waitToSecondPressed (optional) if you want to wait longer
/// condition and conditionFail, if you want show at spesific condition
class DoubleBack extends StatefulWidget {
  final Widget child;
  final String message;
  final int waitForSecondBackPress;
  final Function? onFirstBackPress;
  final bool condition;
  final VoidCallback? onConditionFail;
  final TextStyle textStyle;
  final Color background;
  final double backgroundRadius;

  /// DoubleBack, wrap a widget to use it
  const DoubleBack({
    Key? key,
    required this.child,
    this.message = "Press back again to exit",
    this.waitForSecondBackPress = 2,
    this.onFirstBackPress,
    this.condition = true,
    this.onConditionFail,
    this.textStyle = const TextStyle(fontSize: 14, color: Colors.white),
    this.background = const Color(0xAA000000),
    this.backgroundRadius = 20,
  }) : super(key: key);

  @override
  _DoubleBackState createState() => _DoubleBackState();
}

class _DoubleBackState extends State<DoubleBack> {
  bool tapped = false;
  bool get _isAndroid => Theme.of(context).platform == TargetPlatform.android;

  @override
  Widget build(BuildContext context) {
    if (_isAndroid) {
      return WillPopScope(
        onWillPop: () async {
          if (widget.condition) {
            if (tapped) {
              return true;
            } else {
              tapped = true;
              Timer(
                Duration(
                  seconds: widget.waitForSecondBackPress,
                ),
                resetBackTimeout,
              );

              if (widget.onFirstBackPress != null) {
                widget.onFirstBackPress!(context);
              } else {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(widget.message)));
              }

              return false;
            }
          } else {
            if (widget.onConditionFail != null) {
              widget.onConditionFail!();
            }
            return false;
          }
        },
        child: widget.child,
      );
    } else {
      return widget.child;
    }
  }

  void resetBackTimeout() {
    tapped = false;
  }
}
