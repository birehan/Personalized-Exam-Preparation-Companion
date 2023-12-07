import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skill_bridge_mobile/core/core.dart';
import 'package:skill_bridge_mobile/features/bookmarks/domain/domain.dart';
import 'package:skill_bridge_mobile/features/bookmarks/presentation/bloc/bookmarksBoc/bookmarks_bloc_bloc.dart';

import '../../../../core/widgets/noInternet.dart';
import '../widgets/lesson_bookmark_card.dart';
import '../widgets/question_bookmark_card.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({super.key});

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<BookmarksBlocBloc>().add(GetBookmarksEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int currentIndex = _tabController.index;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 6.h),
            child: const Text(
              'Bookmarks',
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 1.h),
          Padding(
            padding: EdgeInsets.only(left: 10.w, right: 10.w),
            child: Text(
              'Here you can find the questions and lessons you bookmarked',
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  color: Colors.black.withOpacity(.5)),
            ),
          ),
          SizedBox(height: 2.h),
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(
                text: 'Lessons',
              ),
              Tab(
                text: 'Questions',
              ),
            ],
            indicatorColor: const Color(0xff1A7A6C), // Color of the underline
            indicatorWeight: 3.0,
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: const Color(0xff1A7A6C),
            unselectedLabelColor: Colors.black.withOpacity(.5),
          ),
          Expanded(
            child: BlocBuilder<BookmarksBlocBloc, BookmarksBlocState>(
              builder: (context, state) {
                if (state is BookmarksErrorState) {
                  if (state.failure is NetworkFailure) {
                    return NoInternet(
                      reloadCallback: () {
                        context
                            .read<BookmarksBlocBloc>()
                            .add(GetBookmarksEvent());
                      },
                    );
                  }
                  return const Center(
                    child: Text('Unknown Error happend'),
                  );
                } else if (state is BookmarksLoadingState) {
                  return _BookmarksLoadingShimmer();
                } else if (state is BookmarksLoadedState) {
                  List<BookmarkedContent> contents =
                      state.bookmarks.bookmarkedContents;
                  List<BookmarkedQuestions> questions =
                      state.bookmarks.bookmakredQuestions;

                  return TabBarView(
                    controller: _tabController,
                    children: [
                      // Lessons Tab Content
                      contents.isEmpty
                          ? const EmptyListWidget(
                              message: 'No Bookmarked items')
                          : RefreshIndicator(
                              onRefresh: () async {
                                context
                                    .read<BookmarksBlocBloc>()
                                    .add(GetBookmarksEvent());
                              },
                              child: ListView.separated(
                                itemCount: contents
                                    .length, // Replace with your item count
                                itemBuilder: (context, index) {
                                  return LessonBookmarkCard(
                                    bookmarkedContent: contents[index],
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const Divider(),
                              ),
                            ),

                      // Quizzes Tab Content
                      questions.isEmpty
                          ? const EmptyListWidget(
                              message: 'No Bookmarked items')
                          : RefreshIndicator(
                              onRefresh: () async {
                                context
                                    .read<BookmarksBlocBloc>()
                                    .add(GetBookmarksEvent());
                              },
                              child: ListView.separated(
                                itemCount: questions
                                    .length, // Replace with your item count
                                itemBuilder: (context, index) {
                                  return QuestionBookmarkCard(
                                    bookmarkedQeustions: questions[index],
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const Divider(),
                              ),
                            ),
                    ],
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }

  Shimmer _BookmarksLoadingShimmer() {
    return Shimmer.fromColors(
        direction: ShimmerDirection.ltr,
        baseColor: const Color.fromARGB(255, 236, 235, 235),
        highlightColor: const Color(0xffF9F8F8),
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: 3,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
              ),
            );
          },
        ));
  }
}
