// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prep_genie/core/widgets/questions_shimmer.dart';
import 'package:prep_genie/features/bookmarks/presentation/widgets/question_bookmark_quiz_section_card.dart';
import 'package:prep_genie/features/question/presentation/bloc/singleQuestionBloc/single_question_bloc.dart';
import 'package:prep_genie/features/question/presentation/widgets/shared_question_section_card.dart';
import '../../../../core/core.dart';
import '../../../features.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SharedQuestionPage extends StatefulWidget {
  const SharedQuestionPage({
    required this.questionId,
    Key? key,
  }) : super(key: key);
  final String questionId;

  @override
  State<SharedQuestionPage> createState() => _SharedQuestionPageState();
}

class _SharedQuestionPageState extends State<SharedQuestionPage>
    with TickerProviderStateMixin {
  bool showGlow = false;
  late final TabController _tabController;
  @override
  void initState() {
    super.initState();
    context
        .read<SingleQuestionBloc>()
        .add(GetQuestionByIdEvent(questionId: widget.questionId));
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Shared Question',
          style: TextStyle(
              fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<SingleQuestionBloc, SingleQuestionState>(
        builder: (context, state) {
          if (state is SingleQuestionLoadingState) {
            return QuestionShimmerCard();
          }
          if (state is SingleQuestionFailedState) {
            return Center(
              child: Text(state.failure.errorMessage),
            );
          }
          if (state is SingleQuestionLoadedState) {
            return Column(
              children: [
                TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: [
                    Tab(
                      child: Text(
                        AppLocalizations.of(context)!.question,
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          showGlow
                              ? DefaultTextStyle(
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  child: AnimatedTextKit(
                                    animatedTexts: [
                                      FlickerAnimatedText(
                                        AppLocalizations.of(context)!
                                            .explanation,
                                      ),
                                    ],
                                  ),
                                )
                              : Text(
                                  AppLocalizations.of(context)!.explanation,
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      SharedQuestionSectionCard(
                        question: state.question,
                      ),
                      ExplanationWidget(
                        question: state.question,
                        examId: '',
                        questionMode: QuestionMode.analysis,
                        mockType: MockType.bookmarkedQuestion,
                      )
                    ],
                  ),
                ),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}
