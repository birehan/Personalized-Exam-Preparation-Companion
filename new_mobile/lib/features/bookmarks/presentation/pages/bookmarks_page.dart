import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skill_bridge_mobile/core/core.dart';
import 'package:skill_bridge_mobile/features/bookmarks/domain/domain.dart';
import 'package:skill_bridge_mobile/features/bookmarks/presentation/bloc/bookmarksBoc/bookmarks_bloc_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/utils/snack_bar.dart';
import '../../../../core/widgets/noInternet.dart';
import '../widgets/lesson_bookmark_card.dart';
import '../widgets/question_bookmark_card.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({super.key});

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding(
          //   padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 6.h),
          //   child: const Text(
          //     'Bookmarks',
          //     style: TextStyle(
          //         fontFamily: 'Poppins',
          //         fontSize: 24,
          //         fontWeight: FontWeight.bold),
          //   ),
          // ),
          // SizedBox(height: 1.h),
          // Padding(
          //   padding: EdgeInsets.only(left: 10.w, right: 10.w),
          //   child: Text(
          //     'Here you can find the questions and lessons you bookmarked',
          //     style: TextStyle(
          //         fontFamily: 'Poppins',
          //         fontSize: 16,
          //         color: Colors.black.withOpacity(.5)),
          //   ),
          // ),
          // SizedBox(height: 2.h),

          Expanded(
            child: BlocListener<BookmarksBlocBloc, BookmarksBlocState>(
              listener: (context, state) {
                if (state is BookmarksErrorState) {
                  if (state.failure is RequestOverloadFailure) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(snackBar(state.errorMessage));
                  }
                }
              },
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
                    }else if (state.failure is RequestOverloadFailure) {
                return Padding(
                 padding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width *
                        0.10, // 5% of screen width
                    MediaQuery.of(context).size.height *
                        0.25, // 25% of screen height
                    MediaQuery.of(context).size.width *
                        0.10, // 5% of screen width
                    MediaQuery.of(context).size.height *
                        0.25, // 25% of screen height
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            '${state.failure.errorMessage} 🙏',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF797979),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        IconButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xFF18786A)),
                          ),
                          icon: const Icon(
                            Icons.refresh,
                            color: Colors.white,
                            // size: 18,
                          ),
                          onPressed: () {
                           context.read<BookmarksBlocBloc>().add(GetBookmarksEvent());
                          },
                        ),
                      ],
                    ),
                  ),
                );
             
              }
                    return Center(
                      child: Text(AppLocalizations.of(context)!.unkown_error_happened),
                    );
                  } else if (state is BookmarksLoadingState) {
                    return _BookmarksLoadingShimmer();
                  } else if (state is BookmarksLoadedState) {
                    List<BookmarkedContent> contents =
                        state.bookmarks.bookmarkedContents;
                    List<BookmarkedQuestions> questions =
                        state.bookmarks.bookmakredQuestions;

                    return Column(
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _tabIndex = 0;
                                });
                              },
                              child: BookmarksTabWidget(
                                number: contents.length,
                                selected: _tabIndex == 0,
                                title: AppLocalizations.of(context)!.lessons,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _tabIndex = 1;
                                });
                              },
                              child: BookmarksTabWidget(
                                number: questions.length,
                                selected: _tabIndex == 1,
                                title: AppLocalizations.of(context)!.questions,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        // Lessons Tab Content
                        if (_tabIndex == 0)
                          contents.isEmpty
                              ? EmptyListWidget(
                                  message: AppLocalizations.of(context)!.no_bookmark)
                              : Expanded(
                                  child: RefreshIndicator(
                                    onRefresh: () async {
                                      context
                                          .read<BookmarksBlocBloc>()
                                          .add(GetBookmarksEvent());
                                    },
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      itemCount: contents.length,
                                      itemBuilder: (context, index) {
                                        return LessonBookmarkCard(
                                          bookmarkedContent: contents[index],
                                        );
                                      },
                                      separatorBuilder: (context, index) =>
                                          const Divider(),
                                    ),
                                  ),
                                ),
                        // Quizzes Tab Content
                        if (_tabIndex == 1)
                          questions.isEmpty
                              ? EmptyListWidget(
                                  message: AppLocalizations.of(context)!.no_bookmark)
                              : Expanded(
                                  child: RefreshIndicator(
                                    onRefresh: () async {
                                      context
                                          .read<BookmarksBlocBloc>()
                                          .add(GetBookmarksEvent());
                                    },
                                    child: ListView.separated(
                                      shrinkWrap: true,
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
                                ),
                      ],
                    );
                  }
                  return Container();
                },
              ),
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

class BookmarksTabWidget extends StatelessWidget {
  final int number;
  final String title;
  final bool selected;

  const BookmarksTabWidget({
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
