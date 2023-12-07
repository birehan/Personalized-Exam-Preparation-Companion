import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../../../core/widgets/questions_shimmer.dart';
import '../../../features.dart';

class QuizExamQuestionPage extends StatefulWidget {
  const QuizExamQuestionPage({
    super.key,
    required this.courseId,
    required this.quizId,
    required this.questionMode,
  });

  final String courseId;
  final String quizId;
  final QuestionMode questionMode;

  @override
  State<QuizExamQuestionPage> createState() => _QuizExamQuestionPageState();
}

class _QuizExamQuestionPageState extends State<QuizExamQuestionPage> {
  @override
  void initState() {
    super.initState();
    context.read<QuizQuestionBloc>().add(
          GetQuizByIdEvent(
            quizId: widget.quizId,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuizQuestionBloc, QuizQuestionState>(
      builder: (context, state) {
        if (state is GetQuizByIdState &&
            state.status == QuizQuestionStatus.loading) {
          return Scaffold(
            body: QuestionShimmerCard(),
          );
        } else if (state is GetQuizByIdState &&
            state.status == QuizQuestionStatus.loaded) {
          final quizQuestion = state.quizQuestion!;

          return QuizExamQuestionWidget(
            quizExamQuestionWidgetParams: QuizExamQuestionWidgetParams(
              quizQuestion: quizQuestion,
              questionMode: widget.questionMode,
              courseId: widget.courseId,
            ),
          );
        }
        return Container();
      },
    );
  }
}