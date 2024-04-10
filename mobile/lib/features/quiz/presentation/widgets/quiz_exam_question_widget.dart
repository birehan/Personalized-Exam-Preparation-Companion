import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class QuizExamQuestionWidgetParams extends Equatable {
  const QuizExamQuestionWidgetParams({
    required this.quizQuestion,
    required this.questionMode,
    required this.courseId,
  });

  final QuizQuestion quizQuestion;
  final QuestionMode questionMode;
  final String courseId;

  @override
  List<Object?> get props => [
        quizQuestion,
        questionMode,
        courseId,
      ];
}

class QuizExamQuestionWidget extends StatefulWidget {
  final QuizExamQuestionWidgetParams quizExamQuestionWidgetParams;

  const QuizExamQuestionWidget({
    super.key,
    required this.quizExamQuestionWidgetParams,
  });

  @override
  State<QuizExamQuestionWidget> createState() => _QuizExamQuestionWidgetState();
}

class _QuizExamQuestionWidgetState extends State<QuizExamQuestionWidget> {
  List<String> userAnswers = [];

  @override
  void dispose() {
    super.dispose();
  }

  void onSaveScore(int score) {
    bool hasUnansweredQuestion = false;

    if (!hasUnansweredQuestion) {
      context.read<QuizQuestionBloc>().add(
            SaveQuizScoreEvent(
              quizId: widget.quizExamQuestionWidgetParams.quizQuestion.id,
              score: score,
            ),
          );

      QuizResultPageRoute(
        courseId: widget.quizExamQuestionWidgetParams.courseId,
        $extra: ResultPageParams(
            courseId: widget.quizExamQuestionWidgetParams.courseId,
            score: score,
            totalQuestions: widget.quizExamQuestionWidgetParams.quizQuestion
                .questionAnswers.length,
            id: widget.quizExamQuestionWidgetParams.quizQuestion.id,
            examType: ExamType.quiz,
            questionMode: widget.quizExamQuestionWidgetParams.questionMode),
      ).go(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget
        .quizExamQuestionWidgetParams.quizQuestion.questionAnswers.isEmpty) {
      return Scaffold(
        body: Center(
          child: Text(
            'No Questions here yet',
            style: GoogleFonts.poppins(),
          ),
        ),
      );
    }

    return QuestionsPage(
      onSaveScore: onSaveScore,
      questionId: widget.quizExamQuestionWidgetParams.quizQuestion.id,
      questionTitle: widget.quizExamQuestionWidgetParams.quizQuestion.name,
      questions: widget
          .quizExamQuestionWidgetParams.quizQuestion.questionAnswers
          .map((questionAnswer) => questionAnswer.question)
          .toList(),
      userAnswers: widget
          .quizExamQuestionWidgetParams.quizQuestion.questionAnswers
          .map((questionAnswer) => questionAnswer.userAnswer)
          .toList(),
      questionMode: widget.quizExamQuestionWidgetParams.questionMode,
      examType: ExamType.quiz,
      // stackHeight: widget.quizExamQuestionWidgetParams.stackHeight,
    );
  }
}
