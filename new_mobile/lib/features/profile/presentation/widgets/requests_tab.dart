import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

import 'package:skill_bridge_mobile/features/bookmarks/presentation/bloc/bookmarksBoc/bookmarks_bloc_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:skill_bridge_mobile/features/profile/presentation/widgets/receiced_requests_tab.dart';
import 'package:skill_bridge_mobile/features/profile/presentation/widgets/sent_friends_requests_tab.dart';

class RequestsTab extends StatefulWidget {
  const RequestsTab({super.key});

  @override
  State<RequestsTab> createState() => _RequestsTabState();
}

class _RequestsTabState extends State<RequestsTab> {
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();

    context.read<BookmarksBlocBloc>().add(GetBookmarksEvent());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        SizedBox(height: 2.h),
        Row(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  _tabIndex = 0;
                });
              },
              child: RequestsTabWidget(
                number: 12,
                selected: _tabIndex == 0,
                title: 'Sent',
              ),
            ),
            SizedBox(width: 2.w),
            InkWell(
              onTap: () {
                setState(() {
                  _tabIndex = 1;
                });
              },
              child: RequestsTabWidget(
                number: 12,
                selected: _tabIndex == 1,
                title: 'Received',
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        // Lessons Tab Content
        if (_tabIndex == 0)
          // contents.isEmpty
          //     ? EmptyListWidget(
          //         message: AppLocalizations.of(context)!.no_bookmark)
          //     :
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<BookmarksBlocBloc>().add(GetBookmarksEvent());
              },
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: 6,
                itemBuilder: (context, index) {
                  return SentFriendRequestsTab(
                    index: index,
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 2.h),
              ),
            ),
          ),
        // Quizzes Tab Content
        if (_tabIndex == 1)
          // questions.isEmpty
          //     ? EmptyListWidget(
          //         message: AppLocalizations.of(context)!.no_bookmark)
          //     :
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<BookmarksBlocBloc>().add(GetBookmarksEvent());
              },
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: 6,
                itemBuilder: (context, index) {
                  return ReceicedRequestsTab(
                    index: index,
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 1.h),
              ),
            ),
          ),
      ],
    ));
  }

  Shimmer _requestsShimmer() {
    return Shimmer.fromColors(
        direction: ShimmerDirection.ltr,
        baseColor: const Color.fromARGB(255, 236, 235, 235),
        highlightColor: const Color(0xffF9F8F8),
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: 3,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 30.w,
                      height: 6.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Container(
                      width: 30.w,
                      height: 6.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 5.w,
                          height: 5.w,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.w)),
                        ),
                        SizedBox(width: 5.w),
                        Container(
                          width: 30.w,
                          height: 5.w,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)),
                        ),
                      ],
                    ),
                    Container(
                      width: 30.w,
                      height: 5.w,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  ],
                ),
                SizedBox(
                  height: 1.h,
                ),
                Container(
                  width: 70.w,
                  height: 3.h,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Container(
                  width: 80.w,
                  height: 7.h,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                ),
                SizedBox(height: 2.h)
              ],
            );
          },
        ));
  }
}

class RequestsTabWidget extends StatelessWidget {
  final int number;
  final String title;
  final bool selected;

  const RequestsTabWidget({
    super.key,
    required this.number,
    required this.title,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        border: Border.all(
            color: selected ? const Color(0xff18786a) : Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 2.w),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: selected ? const Color(0xff18786a) : Colors.grey),
            child: Text(
              number.toString(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(width: 2.w),
          Text(
            title,
            style: const TextStyle(fontFamily: 'Poppins'),
          ),
        ],
      ),
    );
  }
}
