import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class QuizFormWidget extends StatefulWidget {
  const QuizFormWidget({
    super.key,
    required this.courseId,
  });

  final String courseId;

  @override
  State<QuizFormWidget> createState() => _QuizFormWidgetState();
}

class _QuizFormWidgetState extends State<QuizFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _quizTitleController = TextEditingController();
  final _numberOfQuestionsController = TextEditingController();

  Set<int> chaptersSelected = <int>{};
  List<Chapter> chapters = [];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.quiz_title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          CustomTextFormField(
            controller: _quizTitleController,
            validator: (quizTitle) => validateQuizTitle(quizTitle),
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.number_of_questions,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          CustomTextFormField(
            controller: _numberOfQuestionsController,
            validator: (quizNumber) => validateQuizQuestionsNumber(quizNumber),
          ),
          const SizedBox(height: 24),
          Text(
            AppLocalizations.of(context)!.preferred_chapters,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          BlocBuilder<ChapterBloc, ChapterState>(builder: (context, state) {
            if (state is GetChapterByCourseIdState &&
                state.status == ChapterStatus.loading) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: 5,
                itemBuilder: (s, index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: _shimmerChapterRadioButton(),
                ),
              );
            } else if (state is GetChapterByCourseIdState &&
                state.status == ChapterStatus.loaded) {
              if (state.chapters!.isEmpty) {
                return const EmptyListWidget(message: 'No Quizzes');
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.chapters!.length,
                itemBuilder: (_, index) => ChapterRadioButton(
                  isSelected: chaptersSelected.contains(index),
                  onTap: () {
                    if (chaptersSelected.contains(index)) {
                      setState(() {
                        chaptersSelected.remove(index);
                      });
                    } else {
                      setState(() {
                        chaptersSelected.add(index);
                      });
                    }
                  },
                  chapterIndex: index,
                  chapter: state.chapters![index],
                ),
              );
            }
            return Container();
          }),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: chaptersSelected.isEmpty
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              // Perform further actions with the valid input
                              final chapterState =
                                  context.read<ChapterBloc>().state;

                              if (chapterState is GetChapterByCourseIdState &&
                                  chapterState.status == ChapterStatus.loaded) {
                                setState(() {
                                  chapters = chapterState.chapters!;
                                });
                              }
                              context.read<QuizCreateBloc>().add(
                                    CreateQuizEvent(
                                      name: _quizTitleController.text,
                                      chapters: chaptersSelected
                                          .map(
                                            (index) => chapters[index].id,
                                          )
                                          .toList(),
                                      courseId: widget.courseId,
                                      numberOfQuestions: int.tryParse(
                                            _numberOfQuestionsController.text,
                                          ) ??
                                          1,
                                    ),
                                  );
                            }
                          },
                    child: Text(
                      AppLocalizations.of(context)!.start_quiz,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _shimmerChapterRadioButton() {
    return Shimmer.fromColors(
      direction: ShimmerDirection.ttb,
      baseColor: const Color.fromARGB(255, 236, 235, 235),
      highlightColor: const Color(0xffF9F8F8),
      child: Container(
        height: 8.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
