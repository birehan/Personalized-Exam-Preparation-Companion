import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:prep_genie/core/bloc/localeBloc/locale_bloc.dart';
import 'package:prep_genie/core/constants/app_images.dart';
import 'package:prep_genie/core/routes/go_routes.dart';
import 'package:prep_genie/features/features.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DynamicHomepageProfileHeader extends StatelessWidget {
  const DynamicHomepageProfileHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetUserBloc, GetUserState>(
      builder: (context, state) {
        if (state is GetUserCredentialState &&
            state.status == GetUserStatus.loaded) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    UpdatedProfilePageRoute().go(context);
                  },
                  child: Row(
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF0072FF).withOpacity(.3),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                state.userCredential!.profileAvatar != null
                                    ? state.userCredential!.profileAvatar!
                                    : defaultProfileAvatar),
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${AppLocalizations.of(context)!.greeting(state.userCredential!.firstName)} 👋',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 22,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            AppLocalizations.of(context)!.start_text,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Poppins',
                              color: Colors.black.withOpacity(.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // BlocBuilder<FetchDailyStreakBloc, FetchDailyStreakState>(
                //     builder: (context, state) {
                //   if (state is FetchDailyStreakLoading) {
                //     return _maxStreakShimmer();
                //   } else if (state is FetchDailyStreakLoaded) {
                //     // return _maxStreakShimmer();
                //     return Row(
                //       crossAxisAlignment: CrossAxisAlignment.end,
                //       children: [
                //         const Image(
                //           image: AssetImage('assets/images/fireRed.png'),
                //           height: 30,
                //           width: 30,
                //         ),
                //         Text(
                //           '${state.dailyStreak.totalStreak.maxStreak}',
                //           style: const TextStyle(
                //             fontFamily: 'Poppins',
                //             fontWeight: FontWeight.w600,
                //             fontSize: 18,
                //             color: Color(0xffF53A04),
                //           ),
                //         ),
                //         // Here add small dropdown to select language. there are two languages available
                //       ],
                //     );
                //   } else {
                //     return Container();
                //   }
                // }),
                SizedBox(width: 3.w),
                BlocBuilder<LocaleBloc, LocaleState>(
                  builder: (context, state) {
                    return Container(
                      padding: EdgeInsets.only(top: 1.3.h),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          // icon: const Icon(Icons.language),
                          elevation: 0,
                          value: state.currentLocale == 'en' ? 'En' : 'አማ',
                          alignment: Alignment.centerLeft,
                          isDense: true,
                          borderRadius: BorderRadius.circular(10),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                          items: <String>['En', 'አማ'].map((String value) {
                            return DropdownMenuItem<String>(
                              alignment: Alignment.center,
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val == 'En') {
                              context
                                  .read<LocaleBloc>()
                                  .add(const ChangeLocaleEvent(locale: 'en'));
                            } else if (val == 'አማ') {
                              context
                                  .read<LocaleBloc>()
                                  .add(const ChangeLocaleEvent(locale: 'am'));
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }

  Shimmer _maxStreakShimmer() {
    return Shimmer.fromColors(
      direction: ShimmerDirection.ltr,
      baseColor: const Color.fromARGB(255, 236, 235, 235),
      highlightColor: const Color(0xffF9F8F8),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Image(
            image: AssetImage('assets/images/fireRed.png'),
            height: 30,
            width: 30,
          ),
          Text(
            '0',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Color(0xffF53A04),
            ),
          ),
        ],
      ),
    );
  }
}
