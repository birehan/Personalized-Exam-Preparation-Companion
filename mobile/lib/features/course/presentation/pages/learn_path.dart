import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../core/core.dart';
import '../../../chapter/domain/entities/sub_chapters_list.dart';

import '../../../chapter/presentation/bloc/subChapterBloc/sub_chapter_bloc.dart';
import '../../../features.dart';

class LearningPathPage extends StatefulWidget {
  final UserChapterAnalysis userChapterAnalysis;

  const LearningPathPage({
    super.key,
    required this.userChapterAnalysis,
  });

  @override
  _LearningPathPageState createState() => _LearningPathPageState();
}

class _LearningPathPageState extends State<LearningPathPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                widget.userChapterAnalysis.chapter.name,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          body: BlocBuilder<ChapterBloc, ChapterState>(
            builder: (context, state) {
              if (state is SubChaptersLoadingState) {
                return const Center(
                  child: CustomProgressIndicator(),
                );
              } else if (state is SubChaptersFailedState) {
                return Center(
                  child: Text(state.message),
                );
              } else if (state is SubChaptersLoadedState) {
                List<SubChapterList> subChapters =
                    state.subChapters.subChapterList;
                List<String> completedSubChapters =
                    state.subChapters.completedSubchapters;

                return ListView.builder(
                    itemCount: subChapters.length,
                    itemBuilder: (context, index) {
                      final String title = subChapters[index].subChapterName;

                      return Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: .5.h),
                        decoration: BoxDecoration(
                            color: const Color(0xffE7F0Ef),
                            borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          trailing: completedSubChapters
                                  .contains(subChapters[index].id)
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                )
                              : null,
                          splashColor: const Color(0xff18786A),
                          onTap: () {
                            context.read<SubChapterBloc>().add(
                                  GetSubChapterContentsEvent(
                                    subChapterId: subChapters[index].id,
                                  ),
                                );
                            context.push(AppRoutes.contentpage,
                                extra: widget.userChapterAnalysis);
                          },
                          title: Text(title),
                        ),
                      );
                    });
              }
              return Container();
            },
          )),
    );
  }
}
