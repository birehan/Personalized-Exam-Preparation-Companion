import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skill_bridge_mobile/core/core.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../features.dart';
import 'package:skill_bridge_mobile/features/home/presentation/widgets/dhomepage_dailyquest_card.dart';

class DailyQuestWidget extends StatelessWidget {
  const DailyQuestWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchDailyQuestBloc, FetchDailyQuestState>(
      builder: (context, state) {
        if (state is FetchDailyQuestLoading) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 3.h),
              Column(
                children: List.generate(
                  4,
                  (index) => Container(
                    margin: EdgeInsets.only(bottom: 2.h),
                    child: _dailyQuestCardShimmer(),
                  ),
                ),
              ),
            ],
          );
        } else if (state is FetchDailyQuestLoaded) {
          final dailyQuests = state.dailyQuests
              .where((element) => element.expected > 0)
              .toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 3.h),
              Column(
                children: List.generate(
                  dailyQuests.length,
                  (index) => Container(
                    margin: EdgeInsets.only(bottom: 2.h),
                    // child: _dailyQuestCardShimmer(),
                    child: DailyQuestCard(
                      title:
                          "${dailyQuests[index].challenge[0].toUpperCase()}${dailyQuests[index].challenge.substring(1).toLowerCase()}",
                      taskDesciption: 'completed',
                      iconBackground: index % 2 == 0
                          ? const Color(0xffffc107)
                          : const Color(0xff714625),
                      completedTask: dailyQuests[index].completed,
                      totalTask: dailyQuests[index].expected,
                    ),
                  ),
                ),
              ),
            ],
          );
        } else if (state is FetchDailyQuestFailed) {
          return Center(
            child: SizedBox(
              height: 30.h,
              child: EmptyListWidget(
                showImage: false,
                message: 'Check your internet connection and try again.',
                reloadCallBack: () {
                  context
                      .read<FetchDailyQuestBloc>()
                      .add(const FetchDailyQuestEvent());
                  context
                      .read<HomeBloc>()
                      .add(const GetHomeEvent(refresh: true));
                  context
                      .read<FetchDailyQuizBloc>()
                      .add(const FetchDailyQuizEvent());
                },
              ),
            ),
          );
        }
        return Container();
      },
    );
  }

  Shimmer _dailyQuestCardShimmer() {
    return Shimmer.fromColors(
      direction: ShimmerDirection.ltr,
      baseColor: const Color.fromARGB(255, 236, 235, 235),
      highlightColor: const Color(0xffF9F8F8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.calendar_month_sharp,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 3.w),
              Container(
                width: 45.w,
                height: 2.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ],
          ),
          // SizedBox(height: 1.h),
          Row(
            children: [
              SizedBox(width: 3.w),
              Container(
                height: 6,
                width: 6,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 2.w),
              // Text('$completedTask of $totalTask $taskDesciption'),
              Container(
                width: 40.w,
                height: 1.5.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              SizedBox(height: 1.h),
            ],
          ),
          Row(
            children: [
              SizedBox(width: 3.w),
              Stack(
                children: [
                  Container(
                    width: 70.w,
                    height: 1.5.h,
                    margin:
                        EdgeInsets.only(top: 1.5.h, bottom: 1.5.h, right: 2.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(7),
                        decoration: const BoxDecoration(
                          color: Colors.black12,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.card_giftcard_outlined,
                          color: Colors.black12,
                          size: 18,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(width: 3.w),
              // Text('${totalTask * 10}xp')
              Container(
                width: 10.w,
                height: 1.5.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
