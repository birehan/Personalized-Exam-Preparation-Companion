import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../../../core/widgets/questions_shimmer.dart';
import '../../../features.dart';

class MockExamQuestionPage extends StatefulWidget {
  const MockExamQuestionPage({
    super.key,
    required this.mockId,
    required this.questionMode,
    required this.mockType,
    this.courseImage,
    this.courseName,
    this.isStandard,
  });

  final String mockId;
  final QuestionMode questionMode;
  final MockType mockType;
  final String? courseImage;
  final String? courseName;
  final bool? isStandard;

  @override
  State<MockExamQuestionPage> createState() => _MockExamQuestionPageState();
}

class _MockExamQuestionPageState extends State<MockExamQuestionPage> {
  @override
  void initState() {
    super.initState();
    context.read<MockQuestionBloc>().add(
          GetMockByIdEvent(id: widget.mockId),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MockQuestionBloc, MockQuestionState>(
      builder: (context, state) {
        if (state is GetMockExamByIdState &&
            state.status == MockQuestionStatus.loading) {
          return Scaffold(
            body: QuestionShimmerCard(),
          );
        } else if (state is GetMockExamByIdState &&
            state.status == MockQuestionStatus.loaded) {
          final mock = state.mock!;

          return MockExamQuestionsWidget(
            mockExamQuestionWidgetParams: MockExamQuestionWidgetParams(
              mockType: widget.mockType,
              mock: mock,
              questionMode: widget.questionMode,
              courseImage: widget.courseImage,
              courseName: widget.courseName,
              isStandard: widget.isStandard,
            ),
          );
        }
        return Container();
      },
    );
  }
}
