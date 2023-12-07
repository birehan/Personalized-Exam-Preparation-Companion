import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skill_bridge_mobile/features/bookmarks/presentation/bloc/addContentBookmarkBloc/add_content_bookmark_bloc_bloc.dart';
import 'package:skill_bridge_mobile/features/bookmarks/presentation/bloc/deleteContentBookmark/delete_content_bookmark_bloc.dart';
import '../../../../core/core.dart';
import '../../../../core/widgets/progress_indicator2.dart';
import '../../../chapter/domain/domain.dart';

import '../../../chapter/presentation/bloc/subChapterBloc/sub_chapter_bloc.dart';
import '../../../feedback/presentation/bloc/feedbackBloc/feedback_bloc.dart';
import '../../../feedback/presentation/widgets/flag_dialogue_box.dart';
import '../bloc/course/course_bloc.dart';
import '../bloc/courseWithuserAnalysis/course_with_user_analysis_bloc.dart';
import '../bloc/subChapterRegstration/sub_chapter_regstration_bloc.dart';

class ContentPage extends StatefulWidget {
  const ContentPage({
    super.key,
    required this.courseId,
    this.readOnly,
  });
  final bool? readOnly;
  final String courseId;

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage>
    with SingleTickerProviderStateMixin {
  int currentPageIndex = 0;
  bool get isFirstPage => currentPageIndex == 0;

  late PageController _pageController;
  late Animation<double> _animation;
  late AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    _pageController = PageController(initialPage: currentPageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Set<int> isBookmarked = {};

  @override
  Widget build(BuildContext context) {
    String subChapterId = '';
    String chapterId = '';
    String courseId = '';
    String contentId = '';
    CourseBloc courseBloc = GetIt.instance.get<CourseBloc>();
    CourseState courseState = courseBloc.currentState;
    if (courseState is CoursePopulatedState) {
      courseId = courseState.course.id;
    }
    return MultiBlocListener(
      listeners: [
        BlocListener<SubChapterRegstrationBloc, SubChapterRegstrationState>(
            listener: (context, state) {
          if (state is SubChapterRegstrationSuccessState) {
            // context.read<ChapterBloc>().add(GetSubChaptersEvent(id: chapterId));
            context.read<CourseWithUserAnalysisBloc>().add(
                  // to update the priviously loaded courses
                  GetCourseByIdEvent(id: widget.courseId),
                );
            EndOfSubChapterQuestionsPageRoute(
                    courseId: widget.courseId, subTopicId: subChapterId)
                .go(context);
          } //! add message for the failed state and push
        }),
        BlocListener<FeedbackBloc, FeedbackState>(
          listener: (context, state) {
            if (state is FeedbackSubmitedState) {
              final snackBar = SnackBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                content: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 4)
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Thank you for your feedback 🙏',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                duration: const Duration(seconds: 3),
                behavior: SnackBarBehavior.floating,
              );

              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
        )
      ],
      child: Scaffold(
        floatingActionButton: FloatingOptions(
          hideChat: false,
          flagCallback: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return FlagDialog(
                  index: 0,
                  id: contentId,
                  feedbackType: FeedbackType.contentFeedback,
                );
              },
            );
          },
          chatCallback: () {
            final subChapterState = context.read<SubChapterBloc>().state;
            List<Content> contents = [];

            if (subChapterState is SubChapterLoadedState) {
              setState(() {
                contents = subChapterState.subChapter.contents;
              });
            }
            ChatWithContentPageRoute(
              courseId: widget.courseId,
              subChapterId: contents[currentPageIndex].id,
              readOnly: true,
            ).go(context);
          },
        ),
        floatingActionButtonLocation:
            const CustomFloatingActionButtonLocation(.8, .85),
        appBar: AppBar(
          toolbarHeight: 8.h,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
          ),
          title: Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: BlocBuilder<SubChapterBloc, SubChapterState>(
              builder: (context, state) {
                if (state is SubChapterLoadedState) {
                  return Text(
                    state.subChapter.name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
        ),
        body: BlocBuilder<SubChapterBloc, SubChapterState>(
          builder: (context, state) {
            if (state is SubChapterLoadingState) {
              return const Center(
                child: CustomProgressIndicator(),
              );
            } else if (state is SubChapterFailedState) {
              return Center(
                child: Text(state.message),
              );
            } else if (state is SubChapterLoadedState) {
              final SubChapter subChapter = state.subChapter;
              final List<Content> contents = subChapter.contents;

              int finalPage = contents.length - 1; // set the final page
              subChapterId = subChapter.id;
              chapterId = subChapter.chapterId;
              for (int i = 0; i < contents.length; i++) {
                if (contents[i].isBookmarked) {
                  isBookmarked.add(i);
                }
              }
              if (contents.isEmpty) {
                return const Center(
                  child: Text('No content available'),
                );
              }
              return Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: 5.w, right: 5.w, top: 1.h, bottom: 7.h),
                    child: PageView.builder(
                      itemCount: contents.length,
                      itemBuilder: (context, index) {
                        contentId = contents[currentPageIndex].id;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 3.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      contents[currentPageIndex].title,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: isBookmarked.contains(index)
                                        ? const Icon(Icons.bookmark,
                                            color: Color(0xffFEA800))
                                        : const Icon(Icons.bookmark_outline),
                                    onPressed: () {
                                      Set<int> newBookmarks = isBookmarked;
                                      if (isBookmarked.contains(index)) {
                                        newBookmarks.remove(index);
                                        context
                                            .read<DeleteContentBookmarkBloc>()
                                            .add(BookmarkedContentDeletedEvent(
                                                contentId: contents[index].id));
                                      } else {
                                        newBookmarks.add(index);
                                        context
                                            .read<AddContentBookmarkBlocBloc>()
                                            .add(ContentBookmarkAddedEvent(
                                                contentId: contents[index].id));
                                      }

                                      setState(() {
                                        isBookmarked =
                                            isBookmarked.union(newBookmarks);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            // LaTexT(
                            //   delimiter: r'**',
                            //   laTeXCode: Text(
                            //     contents[currentPageIndex].content,
                            //     // style: Theme.of(context)
                            //     //     .textTheme
                            //     //     .labelMedium!
                            //     //     .copyWith(
                            //     //       color: Color(),
                            //     //     ),
                            //   ),
                            // )

                            Expanded(
                              child: SingleChildScrollView(
                                child: TeXView(
                                  renderingEngine:
                                      const TeXViewRenderingEngine.katex(),
                                  loadingWidgetBuilder: (context) =>
                                      _shimmerContentText(),
                                  child: TeXViewMarkdown(
                                    contents[currentPageIndex].content,
                                    style: TeXViewStyle(
                                      fontStyle: TeXViewFontStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 20,
                                        fontWeight: TeXViewFontWeight.w400,
                                      ),
                                      contentColor:
                                          const Color.fromARGB(255, 87, 87, 87),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      onPageChanged: (index) {
                        setState(() {
                          currentPageIndex = index;
                        });
                      },
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      child: Container(
                        padding: EdgeInsets.all(1.w),
                        width: 100.w,
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                if (!isFirstPage) {
                                  setState(() {
                                    currentPageIndex -= 1;
                                  });
                                }
                              },
                              child: Text(
                                isFirstPage ? "" : 'Prev',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff18786A),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'Section ${currentPageIndex + 1} / ${contents.length}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            finalPage == currentPageIndex
                                ? TextButton(
                                    onPressed: () {
                                      // route to next page
                                      if (widget.readOnly != null &&
                                          widget.readOnly!) {
                                        context.pop();
                                        return;
                                      }
                                      context
                                          .read<SubChapterRegstrationBloc>()
                                          .add(
                                            ResgisterSubChpaterEvent(
                                              chapterId: subChapter.chapterId,
                                              subChapterid: subChapter.id,
                                            ),
                                          );
                                    },
                                    child: BlocBuilder<
                                        SubChapterRegstrationBloc,
                                        SubChapterRegstrationState>(
                                      builder: (context, registrationState) {
                                        if (registrationState
                                            is SubChapterRegstrationLoadingState) {
                                          return const CustomLinearProgressIndicator(
                                            size: 20,
                                          );
                                        }
                                        return const Text(
                                          'Finish',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff18786A),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : TextButton(
                                    onPressed: () {
                                      if (finalPage != currentPageIndex) {
                                        setState(() {
                                          currentPageIndex += 1;
                                        });
                                      }
                                    },
                                    child: const Text(
                                      'Next',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff18786A),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ))
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  _shimmerContentText() {
    return Shimmer.fromColors(
      direction: ShimmerDirection.ttb,
      baseColor: const Color.fromARGB(255, 236, 235, 235),
      highlightColor: const Color(0xffF9F8F8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            24,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Container(
                width: index == 23 ? 40.w : 90.w,
                height: 1.5.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _contentPageLoadShimmer() {
    return Shimmer.fromColors(
      direction: ShimmerDirection.ltr,
      baseColor: const Color.fromARGB(255, 236, 235, 235),
      highlightColor: const Color(0xffF9F8F8),
      child: const Column(),
    );
  }
}
