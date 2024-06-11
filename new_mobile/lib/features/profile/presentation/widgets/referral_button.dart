import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:prep_genie/core/utils/create_links.dart';
import 'package:prep_genie/core/widgets/progress_indicator2.dart';

class ReferalButton extends StatefulWidget {
  const ReferalButton({
    super.key,
    required this.userId,
  });
  final String userId;

  @override
  State<ReferalButton> createState() => _ReferalButtonState();
}

class _ReferalButtonState extends State<ReferalButton> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        setState(() {
          loading = true;
        });
        DynamicLinks.createReferalLink(userId: widget.userId)
            .then((referalLink) {
          setState(() {
            loading = false;
          });
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  alignment: Alignment.centerLeft,
                  // semanticLabel:
                  //     'Scan QR code or share it manually by copying the link',

                  // contentPadding:
                  //     EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  elevation: 2,
                  backgroundColor: Colors.white,
                  title: const Text(
                    'Scan QR code or share it manually by copying the link',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        Share.share(referalLink);
                      },
                      icon: const Icon(Icons.share),
                    ),
                    IconButton(
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(text: referalLink),
                        );
                      },
                      icon: const Icon(Icons.copy),
                    ),
                  ],
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 25.h,
                        width: 50.w,
                        alignment: Alignment.center,
                        child: QrImageView(
                          data: referalLink,
                          version: QrVersions.auto,
                          size: 300.0,
                        ),
                      ),
                      Text(
                        referalLink,
                        style: const TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.black54,
                            fontSize: 18),
                      ),
                    ],
                  ),
                );
              });
        });
      },
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: .75.h),
        decoration: BoxDecoration(
          color: const Color(0xff18786a),
          borderRadius: BorderRadius.circular(5),
        ),
        child: loading
            ? const CustomLinearProgressIndicator(
                color: Colors.white,
                size: 18,
              )
            : const Text(
                'Invite friends',
                style: TextStyle(color: Colors.white),
              ),
      ),
    );
  }
}
