import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markdown_widget/markdown_widget.dart';
// import 'package:flutter_tex/flutter_tex.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:prep_genie/core/widgets/share.dart';
import 'package:prep_genie/features/bookmarks/presentation/bloc/addContentBookmarkBloc/add_content_bookmark_bloc_bloc.dart';
import 'package:prep_genie/features/bookmarks/presentation/bloc/deleteContentBookmark/delete_content_bookmark_bloc.dart';
import '../../../../core/core.dart';
import '../../../../core/utils/snack_bar.dart';
import '../../../../core/widgets/progress_indicator2.dart';
import '../../../features.dart';
import '../../../feedback/presentation/widgets/flag_dialogue_box.dart';
import '../bloc/course/course_bloc.dart';

class DownloadedContentPage extends StatefulWidget {
  const DownloadedContentPage({
    super.key,
    required this.course,
    required this.chapterIdx,
    required this.subChapterIdx,
  });
  final Course course;
  final int chapterIdx;
  final int subChapterIdx;

  @override
  State<DownloadedContentPage> createState() => _DownloadedContentPageState();
}

class _DownloadedContentPageState extends State<DownloadedContentPage>
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
    return Scaffold(
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
          child: Text(
            widget.course.chapters![widget.chapterIdx]
                .subChapters![widget.subChapterIdx].name,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body:
          //         if (contents.isEmpty) {
          //           return const Center(
          //             child: Text('No content available'),
          //           );
          //         }
          Stack(
        children: [
          Padding(
            padding:
                EdgeInsets.only(left: 5.w, right: 5.w, top: 1.h, bottom: 7.h),
            child: PageView.builder(
              itemCount: widget.course.chapters![widget.chapterIdx]
                  .subChapters![widget.subChapterIdx].contents.length,
              itemBuilder: (context, index) {
                final contentId = widget
                    .course
                    .chapters![widget.chapterIdx]
                    .subChapters![widget.subChapterIdx]
                    .contents[currentPageIndex]
                    .id;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 3.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget
                                  .course
                                  .chapters![widget.chapterIdx]
                                  .subChapters![widget.subChapterIdx]
                                  .contents[currentPageIndex]
                                  .title,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: MarkdownWidget(
                        shrinkWrap: true,
                        data: widget
                            .course
                            .chapters![widget.chapterIdx]
                            .subChapters![widget.subChapterIdx]
                            .contents[currentPageIndex]
                            .content,
                        config: MarkdownConfig.defaultConfig,
                        markdownGenerator: MarkdownGenerator(
                          generators: [latexGenerator],
                          inlineSyntaxList: [LatexSyntax()],
                          richTextBuilder: (span) => Text.rich(
                            span,
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF363636),
                              fontSize: 16,
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
                        'Section ${currentPageIndex + 1} / ${widget.course.chapters![widget.chapterIdx].subChapters![widget.subChapterIdx].contents.length}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    widget
                                    .course
                                    .chapters![widget.chapterIdx]
                                    .subChapters![widget.subChapterIdx]
                                    .contents
                                    .length -
                                1 ==
                            currentPageIndex
                        ? TextButton(
                            onPressed: () {
                              context.pop();
                              return;
                            },
                            child: const Text(
                              'Finish',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff18786A),
                              ),
                            ),
                          )
                        : TextButton(
                            onPressed: () {
                              if (widget
                                          .course
                                          .chapters![widget.chapterIdx]
                                          .subChapters![widget.subChapterIdx]
                                          .contents
                                          .length +
                                      1 !=
                                  currentPageIndex) {
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
