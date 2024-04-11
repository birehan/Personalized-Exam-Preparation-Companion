import 'package:flutter/material.dart';

class FloatingChatButton extends StatelessWidget {
  const FloatingChatButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Color(0xff18786a),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5.0,
            spreadRadius: 2.0,
            offset: Offset(2.0, 2.0),
          )
        ],
      ),
      child: Image.asset(
        height: 30,
        width: 30,
        'assets/images/logo_3.png',
        color: Colors.white,
      ),
    );
  }
}
