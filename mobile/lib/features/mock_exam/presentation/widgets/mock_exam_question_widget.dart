import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class MockExamQuestionWidgetParams extends Equatable {
  final Mock mock;
  final QuestionMode questionMode;
  final MockType mockType;
  final String? courseImage;
  final String? courseName;
  final bool? isStandard;

  const MockExamQuestionWidgetParams({
    required this.mock,
    required this.questionMode,
    required this.mockType,
    this.courseImage,
    this.courseName,
    this.isStandard,
  });

  @override
  List<Object?> get props => [
        mock,
        questionMode,
        mockType,
        courseImage,
        courseName,
        mockType,
        isStandard,
      ];
}

class MockExamQuestionsWidget extends StatefulWidget {
  const MockExamQuestionsWidget({
    super.key,
    required this.mockExamQuestionWidgetParams,
  });

  final MockExamQuestionWidgetParams mockExamQuestionWidgetParams;

  @override
  State<MockExamQuestionsWidget> createState() =>
      _MockExamQuestionsWidgetState();
}

class _MockExamQuestionsWidgetState extends State<MockExamQuestionsWidget> {
  void onSaveScore(int score) {
    bool hasUnansweredQuestion = false;

    if (!hasUnansweredQuestion) {
      context.read<UpsertMockScoreBloc>().add(
            UpsertMyMockScoreEvent(
              mockId: widget.mockExamQuestionWidgetParams.mock.id,
              score: score,
            ),
          );

      switch (widget.mockExamQuestionWidgetParams.mockType) {
        case MockType.recommendedMocks:
          RecommendedMockResultPageRoute(
            $extra: ResultPageParams(
              score: score,
              totalQuestions:
                  widget.mockExamQuestionWidgetParams.mock.mockQuestions.length,
              id: widget.mockExamQuestionWidgetParams.mock.id,
              examType: ExamType.standardMock,
              mockType: MockType.recommendedMocks,
            ),
          ).go(context);
          break;
        case MockType.standardMocks:
          StandardMockResultPageRoute(
            courseImage: widget.mockExamQuestionWidgetParams.courseImage!,
            courseName: widget.mockExamQuestionWidgetParams.courseName!,
            isStandard: true,
            $extra: ResultPageParams(
              courseImage: widget.mockExamQuestionWidgetParams.courseImage!,
              courseName: widget.mockExamQuestionWidgetParams.courseName!,
              score: score,
              totalQuestions:
                  widget.mockExamQuestionWidgetParams.mock.mockQuestions.length,
              id: widget.mockExamQuestionWidgetParams.mock.id,
              examType: ExamType.standardMock,
              mockType: MockType.standardMocks,
            ),
          ).go(context);
          break;
        case MockType.myStandardMocks:
          RecommendedMockResultPageRoute(
            $extra: ResultPageParams(
              score: score,
              totalQuestions:
                  widget.mockExamQuestionWidgetParams.mock.mockQuestions.length,
              id: widget.mockExamQuestionWidgetParams.mock.id,
              examType: ExamType.standardMock,
              mockType: MockType.myStandardMocks,
            ),
          ).go(context);
          break;
        case MockType.myAIGeneratedMocks:
          RecommendedMockResultPageRoute(
            $extra: ResultPageParams(
              score: score,
              totalQuestions:
                  widget.mockExamQuestionWidgetParams.mock.mockQuestions.length,
              id: widget.mockExamQuestionWidgetParams.mock.id,
              examType: ExamType.standardMock,
              mockType: MockType.myAIGeneratedMocks,
            ),
          ).go(context);
          break;
        default:
          RecommendedMockResultPageRoute(
            $extra: ResultPageParams(
              score: score,
              totalQuestions:
                  widget.mockExamQuestionWidgetParams.mock.mockQuestions.length,
              id: widget.mockExamQuestionWidgetParams.mock.id,
              examType: ExamType.standardMock,
              mockType: MockType.recommendedMocks,
            ),
          ).go(context);
          break;
      }
    }
  }

  void onGoToAnalysis() {
    switch (widget.mockExamQuestionWidgetParams.mockType) {
      case MockType.recommendedMocks:
        break;
      case MockType.standardMocks:
        break;
      case MockType.myStandardMocks:
        break;
      case MockType.myAIGeneratedMocks:
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mockExamQuestionWidgetParams.mock.mockQuestions.isEmpty) {
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
      courseName: widget.mockExamQuestionWidgetParams.courseName,
      courseImage: widget.mockExamQuestionWidgetParams.courseImage,
      onSaveScore: onSaveScore,
      questionId: widget.mockExamQuestionWidgetParams.mock.id,
      questionTitle: widget.mockExamQuestionWidgetParams.mock.name,
      questions: widget.mockExamQuestionWidgetParams.mock.mockQuestions
          .map((mockQuestion) => mockQuestion.question)
          .toList(),
      userAnswers: widget.mockExamQuestionWidgetParams.mock.mockQuestions
          .map((mockQuestion) => mockQuestion.userAnswer)
          .toList(),
      questionMode: widget.mockExamQuestionWidgetParams.questionMode,
      examType: ExamType.standardMock,
      mockType: widget.mockExamQuestionWidgetParams.mockType,
      isStandard: widget.mockExamQuestionWidgetParams.isStandard,
      // stackHeight: mockExamQuestionPageParams.stackHeight,
    );
  }
}
