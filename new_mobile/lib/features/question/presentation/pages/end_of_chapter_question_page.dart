import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:prep_genie/features/question/presentation/bloc/endOfChaptersQuestionsBloc/endof_chapter_questions_bloc.dart';

import '../../../../core/core.dart';
import '../../../../core/utils/snack_bar.dart';
import '../../../../core/widgets/questions_shimmer.dart';
import '../../../features.dart';

class EndOfChapterQuestionsPage extends StatefulWidget {
  final String chapterId;
  const EndOfChapterQuestionsPage({
    super.key,
    required this.chapterId,
    required this.courseId,
  });

  final String courseId;

  @override
  State<EndOfChapterQuestionsPage> createState() =>
      _EndOfChapterQuestionsPageState();
}

class _EndOfChapterQuestionsPageState extends State<EndOfChapterQuestionsPage> {
  String userAnswer = '';
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
            BlocListener<EndofChapterQuestionsBloc, EndofChapterQuestionsState>(
      listener: (context, state) {
        if (state is EndofChapterQuestionsErrorState) {
          if (state.failure is RequestOverloadFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(snackBar(state.failure.errorMessage));
          }
        }
      },
      child: BlocBuilder<EndofChapterQuestionsBloc, EndofChapterQuestionsState>(
          builder: (context, state) {
        if (state is EndofChapterQuestionsErrorState) {
          return const Center(child: Text("Error getting Courses"));
        } else if (state is EndofChapterQuestionsSuccessState) {
          if (state.endSubtopicQuestionAnswers.isEmpty) {
            return Center(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const EmptyListWidget(
                        message:
                            'No questions prepared at the moment. Please check back later.',
                      ),
                      IconButton(
                          onPressed: () {
                            context.pop();
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Color(0xFF0072FF),
                          ))
                    ],
                  )),
            );
          }
          return PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {},
            itemCount: state.endSubtopicQuestionAnswers.length,
            itemBuilder: (context, index) {
              return SubtopicQuestionPage(
                questions: state.endSubtopicQuestionAnswers
                    .map((questionAnswer) => questionAnswer.question)
                    .toList(),
                courseId: widget.courseId,
              );
            },
          );
        }
        return QuestionShimmerCard();
      }),
    ));
  }
}
