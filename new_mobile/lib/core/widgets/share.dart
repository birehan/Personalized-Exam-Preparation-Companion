import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:skill_bridge_mobile/core/utils/create_links.dart';

class ShareButton extends StatefulWidget {
  const ShareButton({
    super.key,
    required this.route,
    required this.subject,
  });
  final String route;
  final String subject;

  @override
  State<ShareButton> createState() => _ShareButtonState();
}

class _ShareButtonState extends State<ShareButton> {
  bool isShareInProgress = false;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        log('Sharing content: ${widget.route}');
        if (isShareInProgress) return;
        setState(() {
          isShareInProgress = true;
        });
        DynamicLinks.createDynamicLink(route: widget.route).then((value) {
          setState(() {
            isShareInProgress = false;
          });
          Share.share(
            value,
            subject: widget.subject,
          );
        });
      },
      icon: const Icon(Icons.share),
    );
  }
}
