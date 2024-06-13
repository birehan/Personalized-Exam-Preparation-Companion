import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markdown_widget/markdown_widget.dart';

import '../../../../core/constants/app_enums.dart';
import '../../../../core/core.dart';
import '../../../../core/routes/go_routes.dart';
import '../../../../core/widgets/floating_options.dart';
import '../../../features.dart';
// import '../../../feedback/presentation/widgets/flag_dialogue_box.dart';

class SubtopicQuestionPage extends StatefulWidget {
  const SubtopicQuestionPage({
    super.key,
    required this.questions,
    required this.courseId,
  });

  final List<Question> questions;
  final String courseId;

  @override
  State<SubtopicQuestionPage> createState() => _SubtopicQuestionPageState();
}

class _SubtopicQuestionPageState extends State<SubtopicQuestionPage> {
  List<bool> isAnswerSelected = [];
  List<String> userAnswer = [];
  List<bool> wrongAnswer = [];

  final _pageController = PageController();
  int currentIndex = 0;
  int score = 0;

  @override
  void initState() {
    super.initState();

    isAnswerSelected = widget.questions.map((_) => false).toList();
    userAnswer = widget.questions.map((_) => '').toList();
    wrongAnswer = widget.questions.map((_) => false).toList();

    _pageController.addListener(() {
      setState(() {
        currentIndex = _pageController.page?.round() ?? 0;
      });
    });
  }

  void goTo(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
