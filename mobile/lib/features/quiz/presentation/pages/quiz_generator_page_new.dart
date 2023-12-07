import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skill_bridge_mobile/core/core.dart';

import '../../../features.dart';

class CreateQuizPage extends StatefulWidget {
  const CreateQuizPage({
    super.key,
    required this.courseId,
  });

  final String courseId;

  @override
  State<CreateQuizPage> createState() => _CreateQuizPageState();
}

class _CreateQuizPageState extends State<CreateQuizPage> {
  @override
  void initState() {
    super.initState();

    context
        .read<ChapterBloc>()
        .add(GetChapterByCourseIdEvent(courseId: widget.courseId));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<QuizCreateBloc, QuizCreateState>(
          listener: (context, state) {
            if (state is CreateQuizState &&
                state.status == QuizCreateStatus.loaded) {
              showDialog(
                context: context,
                builder: (BuildContext context) => LearningQuizModeDialog(
                  examId: state.quizId!,
                ),
              );
            } else if (state is CreateQuizState &&
                state.status == QuizCreateStatus.error) {
              final snackBar = SnackBar(
                content: Text(
                  state.errorMessage!,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.red,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
        ),
        BlocListener<AlertDialogBloc, AlertDialogState>(
          listener: (context, state) {
            if (state is LearningQuizModeState &&
                state.status == AlertDialogStatus.loaded) {
              QuizQuestionPageRoute(
                courseId: widget.courseId,
                quizId: state.examId!,
                $extra: state.questionMode!,
              ).go(context);

              // CreatedQuizQuestionPageRoute(
              //   courseId: widget.courseId,
              //   quizId: widget.quizId,
              // );
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Let\'s create questions based on your preference',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 32),
                QuizFormWidget(
                  courseId: widget.courseId,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
