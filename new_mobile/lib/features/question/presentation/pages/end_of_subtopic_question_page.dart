import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/core.dart';
import '../../../../core/utils/snack_bar.dart';
import '../../../../core/widgets/questions_shimmer.dart';
import '../../../features.dart';

class EndOfSubtopicQuestionsPage extends StatefulWidget {
  final String subTopicId;
  const EndOfSubtopicQuestionsPage({
    super.key,
    required this.subTopicId,
    required this.courseId,
  });

  final String courseId;

  @override
  State<EndOfSubtopicQuestionsPage> createState() =>
      _EndOfSubtopicQuestionsPageState();
}

class _EndOfSubtopicQuestionsPageState
    extends State<EndOfSubtopicQuestionsPage> {
  String userAnswer = '';
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    context
        .read<QuestionBloc>()
        .add(EndSubtopicQuestionAnswerEvent(subtopicId: widget.subTopicId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocListener<QuestionBloc, QuestionState>(
      listener: (context, state) {
        if (state is EndSubtopicQuestionUserState &&
            state.status == QuestionStatus.error) {
          if (state.failure is RequestOverloadFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(snackBar(state.failure!.errorMessage));
          }
        }
      },
      child:
          BlocBuilder<QuestionBloc, QuestionState>(builder: (context, state) {
        if (state is EndSubtopicQuestionUserState &&
            state.status == QuestionStatus.error) {
          return const Center(child: Text("Error getting Courses"));
        } else if (state is EndSubtopicQuestionUserState &&
            state.status == QuestionStatus.loaded) {
          if (state.endSubtopicQuestionAnswer!.isEmpty) {
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
            itemCount: state.endSubtopicQuestionAnswer!.length,
            itemBuilder: (context, index) {
              return SubtopicQuestionPage(
                questions: state.endSubtopicQuestionAnswer!
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
