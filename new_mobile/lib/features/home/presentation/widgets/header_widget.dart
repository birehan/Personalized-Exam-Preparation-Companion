import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/core.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget(
      {super.key,
      required this.name,
      this.imageAddress,
      required this.navigateToSettings});

  final String name;
  final String? imageAddress;
  final VoidCallback navigateToSettings;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${AppLocalizations.of(context)!.hello}, $name',
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF5D5A6F),
          ),
        ),
        InkWell(
          onTap: () {
            AppRoutes.settingsPage;
          },
          child: InkWell(
            onTap: navigateToSettings,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(7.h),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 2,
                        color: Colors.grey.withOpacity(0.1),
                        offset: const Offset(1, 5)),
                  ],
                  border: Border.all(
                    color: const Color(0XFF18786A),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(7.h),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: imageAddress != ''
                        ? NetworkImage(
                            imageAddress!,
                          )
                        : const AssetImage('assets/images/profile_avatar.png')
                            as ImageProvider<Object>,
                  ),
                ),
                height: 7.h,
                width: 7.h,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
