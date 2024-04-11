import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_tex/flutter_tex.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skill_bridge_mobile/features/bookmarks/domain/domain.dart';

import '../../../../core/core.dart';
import '../bloc/addContentBookmarkBloc/add_content_bookmark_bloc_bloc.dart';
import '../bloc/bookmarksBoc/bookmarks_bloc_bloc.dart';
import '../bloc/deleteContentBookmark/delete_content_bookmark_bloc.dart';

class BookmarkedContentPage extends StatefulWidget {
  const BookmarkedContentPage({
    super.key,
    required this.bookmarkedContent,
  });

  final BookmarkedContent bookmarkedContent;
  @override
  State<BookmarkedContentPage> createState() => _BookmarkedContentPageState();
}

class _BookmarkedContentPageState extends State<BookmarkedContentPage> {
  bool isBookmarked = true;

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
            widget.bookmarkedContent.content.title,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 3.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.bookmarkedContent.content.title,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: isBookmarked
                          ? const Icon(Icons.bookmark, color: Color(0xffFEA800))
                          : const Icon(Icons.bookmark_outline),
                      onPressed: () {
                        String contentId = widget.bookmarkedContent.content.id;

                        if (isBookmarked) {
                          context.read<DeleteContentBookmarkBloc>().add(
                              BookmarkedContentDeletedEvent(
                                  contentId: contentId));
                        } else {
                          context.read<AddContentBookmarkBlocBloc>().add(
                              ContentBookmarkAddedEvent(contentId: contentId));
                        }
                        setState(() {
                          isBookmarked = !isBookmarked;
                        });
                        context
                            .read<BookmarksBlocBloc>()
                            .add(GetBookmarksEvent());
                      },
                    ),
                  ],
                ),
              ),
              // SelectableText(
              //   widget.bookmarkedContent.content.content,
              //   style: TextStyle(
              //     fontSize: 18.sp,
              //     height: 1.7,
              //   ),
              // ),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: MarkdownWidget(
                  shrinkWrap: true,
                  data: widget.bookmarkedContent.content.content,
                  config: MarkdownConfig.defaultConfig,
                  markdownGenerator: MarkdownGenerator(
                    generators: [latexGenerator],
                    inlineSyntaxList: [LatexSyntax()],
                    richTextBuilder: (span) => Text.rich(
                      span,
                      style: GoogleFonts.poppins(),
                    ),
                  ),
                ),
              ),
              // TeXView(
              //   loadingWidgetBuilder: (context) => _shimmerBookmarkedContent(),
              //   child: TeXViewMarkdown(
              //     widget.bookmarkedContent.content.content,
              //     style: TeXViewStyle(
              //       fontStyle: TeXViewFontStyle(
              //         fontFamily: 'Poppins',
              //         fontSize: 20,
              //         fontWeight: TeXViewFontWeight.w400,
              //       ),
              //       contentColor: const Color(0xFF212121),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  _shimmerBookmarkedContent() {
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
}
