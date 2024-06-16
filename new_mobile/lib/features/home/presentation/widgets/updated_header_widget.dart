import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../core/core.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../features.dart';

class UpdatedHeaderWidget extends StatelessWidget {
  const UpdatedHeaderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetUserBloc, GetUserState>(
      builder: (context, state) {
        if (state is GetUserCredentialState &&
            state.status == GetUserStatus.loaded) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '👋 ${AppLocalizations.of(context)!.hey} ${state.userCredential!.firstName},',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${AppLocalizations.of(context)!.let_us_begin_your_journey} 🎉',
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  UpdatedProfilePageRoute().go(context);
                },
                child: Stack(
                  children: [
                    state.userCredential!.profileAvatar != null &&
                            state.userCredential!.profileAvatar != ''
                        ? Padding(
                            padding: const EdgeInsets.only(top: 3, right: 3),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: CachedNetworkImage(
                                imageUrl: state.userCredential!.profileAvatar!,
                                width: 6.h,
                                height: 6.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        //
                        : Padding(
                            padding: const EdgeInsets.only(top: 3, right: 3),
                            child: Container(
                              width: 6.h,
                              height: 6.h,
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                  image: const DecorationImage(
                                    fit: BoxFit.contain,
                                    image: CachedNetworkImageProvider(
                                        'https://res.cloudinary.com/demo/image/upload/d_avatar.png/non_existing_id.png'),
                                  )),
                            ),
                          ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 1.5.h,
                        height: 1.5.h,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
        return Container();
      },
    );
  }
}
